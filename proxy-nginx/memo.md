### Nginx の停止
`nginx -s stop`

### Nginx の起動
`nginx`

### tailscale SSH起動
tailscale up -ssh -hostname nginx
### tailscale funnel
tailscale funnel -bg -https=443 80