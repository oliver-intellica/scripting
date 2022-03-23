# Extracts and prints to STDOUT unique URLS of links to the same site.
curl https://www.example.com | grep "https://www.example.com" | sed 's/https/\nhttps/g' | grep ^https://www.example.com |  sed 's/\(^http[^"]\)\(.\)/\1/g' | grep http | sort -u
