#!/bin/bash
# Chạy mỗi phút (launchd vn.netdoor.xuongtieupham.link): link trycloudflare đổi → dựng lại trang chuyển hướng + đẩy GitHub Pages.
export PATH="$HOME/.local/bin:/opt/homebrew/bin:/usr/local/bin:/usr/bin:/bin"
cd "$(dirname "$0")" || exit 1
U=$(grep -oE 'https://[a-z0-9-]+\.trycloudflare\.com' "$HOME/agentic-netdoor/xuong-tieu-pham/dashboard/log/tunnel.log" | tail -1)
[ -z "$U" ] && exit 0
if [ "$U" != "$(cat url.txt 2>/dev/null)" ] || [ "$1" = "--ep" ]; then
  curl -s -o /dev/null --max-time 15 -w "%{http_code}" "$U/" | grep -q 200 || exit 0
  sed -e "s#__DICH__#$U#g" -e "s#__TIEUDE__#Xưởng Tiểu Phẩm#g" mau.html > index.html
  echo "$U" > url.txt
  git add -A && git -c user.name="nguoidongchi-netizen" -c user.email="nguoidongchi@gmail.com" commit -qm "Link mới $(date '+%d/%m %H:%M')" && git push -q && echo "$(date '+%F %T') đã cập nhật $U"
fi
