#!/usr/bin/env bash
# set -x

HOST=<IP-or-hostname>
PORT=5432
DB=<database-name>
SCHEMA=public
USER=<database-user>
PASS=<database-password>

declare -rA HOSTS=( ['rpi']='eth' ['nando']='wlan' ['company']='ppp' )
declare -A BOUNDS=( ['rpi']="9000,10000" ['nando']="19000,17000" ['company']="11000,10000" )

DELTA=$(( 60 * 24 * 3 ))
MODEL="INSERT INTO $SCHEMA.sensor_data VALUES ('%HOST%', '%TS%', '{\"cxn\": \"%DEV%\", \"in\": \"%IN%\", \"out\": \"%OUT%\"}')"
echo "Inserting data from $(date --date="$DELTA minutes ago" '+%F %T')"

db="psql -h $HOST -p $PORT -U $USER $DB"
PGPASSWORD=$PASS $db -c "CREATE TABLE IF NOT EXISTS $SCHEMA.sensor_data (device text, collected_at timestamp, net_data text NULL)" >/dev/null
echo "Current rows in $SCHEMA.sensor_data: $(PGPASSWORD=$PASS eval "$db -t -A -c \"SELECT COUNT(*) FROM $SCHEMA.sensor_data\"")"


while [ $DELTA -gt 0 ]; do
    T=$(date --date="$DELTA minutes ago" '+%F %T')
    shuffled=$(printf "%s\n" "${!HOSTS[@]}" | shuf)

    nullify=
    for host in $shuffled; do
        device="${HOSTS[$host]}"
        in=$(( $(echo "${BOUNDS[$host]}" | cut -d, -f1) + ( $RANDOM / 100 ) ))
        out=$(( $(echo "${BOUNDS[$host]}" | cut -d, -f2) + ( $RANDOM / 100 ) ))

        PGPASSWORD=$PASS $db -c "$(echo "$MODEL" | sed "s,%HOST%,$host,;s,%TS%,$T,;s,%DEV%,$device,;s,%IN%,$in,;s,%OUT%,$out,")" >/dev/null &

        BOUNDS[$host]=$in,$out
        [ -z "$nullify" ] && nullify=$host || true
    done

    if echo "$T" | grep -q -e ":00:" -e ":07:"; then
        echo "Create NULL: WHERE device = '$nullify' AND collected_at = '$T'"
        PGPASSWORD=$PASS $db -c "UPDATE $SCHEMA.sensor_data SET net_data = NULL WHERE device = '$nullify' AND collected_at = '$T'" >/dev/null
    fi

    DELTA=$(( DELTA - 1 ))
done

echo "Rows in $SCHEMA.sensor_data: $(PGPASSWORD=$PASS eval "$db -t -A -c \"SELECT COUNT(*) FROM $SCHEMA.sensor_data\"")"
