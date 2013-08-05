mailq | grep ^[A-Z\|0-9] | awk '{print $7}' | cut -d@ -f2 | sort | uniq -c | sort -rn  | head -15
