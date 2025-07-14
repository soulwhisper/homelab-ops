## Moviepilot

- bt auto lib
  `curl "http://moviepilot:3000/api/v1/transfer/now?token=moviepilot"`
- admin password
  `kubectl logs -n media-apps moviepilot | grep "超级管理员初始密码"`
- notify via webPush, [ref](https://wiki.movie-pilot.org/zh/notification)
