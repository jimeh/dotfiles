# Flush DNS cache
alias flush_dns="dscacheutil -flushcache"

# Apache related
alias start_apache="sudo apachectl start"
alias stop_apache="sudo apachectl stop"
alias restart_apache="sudo apachectl restart"

# NAMED DNS Server
NAMED_LAUNCHD_CONFIG="/System/Library/LaunchDaemons/org.isc.named.plist"
alias start_named="sudo launchctl load $NAMED_LAUNCHD_CONFIG"
alias stop_named="sudo launchctl unload $NAMED_LAUNCHD_CONFIG"
alias restart_named="stop_named; start_named"
alias reload_dns="restart_named" # legacy

# Memcache related
MEMCACHED_LAUNCHD_CONFIG="~/Library/LaunchAgents/com.danga.memcached.plist"
alias start_memcached="launchctl load -w $MEMCACHED_LAUNCHD_CONFIG"
alias stop_memcached="launchctl unload -w $MEMCACHED_LAUNCHD_CONFIG;"
alias restart_memcached="stop_memcached; start_memcached"

# MySQL related
MYSQL_LAUNCHD_CONFIG="~/Library/LaunchAgents/com.mysql.mysqld.plist"
alias start_mysql="launchctl load -w $MYSQL_LAUNCHD_CONFIG"
alias stop_mysql="launchctl unload -w $MYSQL_LAUNCHD_CONFIG;"
alias restart_mysql="stop_mysql; start_mysql"

# Redis related
REDIS_LAUNCHD_CONFIG="~/Library/LaunchAgents/io.redis.redis-server.plist"
alias start_redis="launchctl load -w $REDIS_LAUNCHD_CONFIG"
alias stop_redis="launchctl unload -w $REDIS_LAUNCHD_CONFIG;"
alias restart_redis="stop_redis; start_redis"
