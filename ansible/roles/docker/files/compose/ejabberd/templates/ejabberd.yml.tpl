###
###              ejabberd configuration file
###
###       https://docs.ejabberd.im/admin/configuration
###
### Customized template from:
### https://raw.githubusercontent.com/rroemhild/docker-ejabberd/master/conf/ejabberd.yml.tpl
### https://github.com/processone/ejabberd/blob/master/ejabberd.yml.example
### 
###   =======
###   LOGGING

loglevel: {{ env['EJABBERD_LOGLEVEL'] or 4 }}
log_rotate_size: 10485760
log_rotate_count: 0

###   =======
###   LOCALE
language: "en"

###   ================
###   SERVED HOSTNAMES

hosts:
{%- for xmpp_domain in env['XMPP_DOMAIN'].split() %}
  - "{{ xmpp_domain }}"
{%- endfor %}

### ====
### TLS
define_macro:
  'TLS_CIPHERS': "HIGH:!3DES:!aNULL:!SSLv2:@STRENGTH"
  'TLS_OPTIONS':
    - "no_sslv2"
    - "no_sslv3"
    {%- if env.get('EJABBERD_PROTOCOL_OPTIONS_TLSV1', "false") == "false" %}
    - "no_tlsv1"
    {%- endif %}
    {%- if env.get('EJABBERD_PROTOCOL_OPTIONS_TLSV1_1', "true") == "false" %}
    - "no_tlsv1_1"
    {%- endif %}
    - "cipher_server_preference"

c2s_ciphers: "{{ env.get('EJABBERD_CIPHERS', 'HIGH:!aNULL:!3DES') }}"
c2s_protocol_options: 'TLS_OPTIONS'
{%- if env.get('EJABBERD_DHPARAM', false) == "true" %}
c2s_dhfile: "/opt/ejabberd/ssl/dh2048.pem"
{%- endif %}

###   CERTIFICATES
###   ================
certfiles:
  - "/opt/ejabberd/ssl/{{ xmpp_domain }}.pem"


###   =======
###   MODULES
listen:
  -
    port: 5222
    ip: "::"
    module: ejabberd_c2s
    max_stanza_size: 262144
    shaper: c2s_shaper
    access: c2s
    starttls_required: true
  -
    port: 5269
    ip: "::"
    module: ejabberd_s2s_in
    max_stanza_size: 524288
  -
    port: 5443
    ip: "::"
    module: ejabberd_http
    tls: true
    request_handlers:
      "/admin": ejabberd_web_admin
      "/api": mod_http_api
      "/bosh": mod_bosh
      "/captcha": ejabberd_captcha
      "/upload": mod_http_upload
      "/ws": ejabberd_http_ws
      "/oauth": ejabberd_oauth
  -
    port: 5280
    ip: "::"
    module: ejabberd_http
    request_handlers:
      "/admin": ejabberd_web_admin
  -
    port: 1883
    ip: "::"
    module: mod_mqtt
    backlog: 1000


###   ==============
###   AUTHENTICATION
auth_method:
{%- for auth_method in env.get('EJABBERD_AUTH_METHOD', 'internal').split() %}
  - {{ auth_method }}
{%- endfor %}

auth_password_format: {{ env.get('EJABBERD_AUTH_PASSWORD_FORMAT', 'scram') }}

{%- if 'anonymous' in env.get('EJABBERD_AUTH_METHOD', 'internal').split() %}
anonymous_protocol: both
allow_multiple_connections: true
{%- endif %}

###   SERVER TO SERVER
###   ================
s2s_use_starttls: required

###   ====================
###   ACCESS CONTROL LISTS
acl:
  local:
    user_regexp: ""
  loopback:
    ip:
      - 127.0.0.0/8
      - ::1/128
      - ::FFFF:127.0.0.1/128
  admin:
    user:
    {%- if env['EJABBERD_ADMINS'] %}
      {%- for admin in env['EJABBERD_ADMINS'].split() %}
      - "{{ admin.split('@')[0] }}": "{{ admin.split('@')[1] }}"
      {%- endfor %}
    {%- else %}
      - "admin": "{{ env['XMPP_DOMAIN'].split()[0] }}"
    {%- endif %}

###   =======
###   API PERMISSIONS
api_permissions:
  "console commands":
    from:
      - ejabberd_ctl
    who: all
    what: "*"
  "admin access":
    who:
      access:
        allow:
          acl: loopback
          acl: admin
      oauth:
        scope: "ejabberd:admin"
        access:
          allow:
            acl: loopback
            acl: admin
    what:
      - "*"
      - "!stop"
      - "!start"
  "public commands":
    who:
      ip: 127.0.0.1/8
    what:
      - status
      - connected_users_number

###   ===============
###   TRAFFIC SHAPERS
shaper:
  normal:
    rate: 10000
    burst_size: 30000
  fast: 100000

shaper_rules:
  max_user_sessions: 10
  max_user_offline_messages:
    5000: admin
    100: all
  c2s_shaper:
    none: admin
    normal: all
  s2s_shaper: fast

max_fsm_queue: 10000

###   ============
###   ACCESS RULES
access_rules:
  local:
    allow: local
  c2s:
    deny: blocked
    allow: all
  announce:
    allow: admin
  configure:
    allow: admin
  muc_create:
    allow: local
  pubsub_createnode:
    allow: local
  trusted_network:
    allow: loopback

###   =======
###   MODULES
modules:
  mod_adhoc: {}
  mod_admin_extra: {}
  mod_announce:
    access: announce
  mod_avatar: {}
  mod_blocking: {}
  mod_bosh: {}
  mod_caps: {}
  mod_carboncopy: {}
  mod_client_state: {}
  mod_configure: {}
  mod_disco: {}
  mod_fail2ban: {}
  mod_http_api: {}
  mod_http_upload:
    put_url: https://@HOST@:5443/upload
  mod_http_upload_quota:
    max_days: {{ env.get('EJABBERD_UPLOAD_QUOTA_MAX_DAYS', 10) }}
  mod_last: {}
  mod_mam:
    ## Mnesia is limited to 2GB, better to use an SQL backend
    ## For small servers SQLite is a good fit and is very easy
    ## to configure. Uncomment this when you have SQL configured:
    ## db_type: sql
    assume_mam_usage: true
    default: never
  mod_mqtt: {}
  mod_muc:
    access:
      - allow
    access_admin:
      - allow: admin
    access_create: muc_create
    access_persistent: muc_create
    access_mam:
      - allow
    default_room_options:
      allow_subscription: true  # enable MucSub
      mam: false
  mod_muc_admin: {}
  mod_offline:
    access_max_user_messages: max_user_offline_messages
  mod_ping: {}
  mod_privacy: {}
  mod_private: {}
  mod_proxy65:
    access: local
    max_connections: 5
  mod_pubsub:
    access_createnode: pubsub_createnode
    plugins:
      - flat
      - pep
    force_node_config:
      ## Avoid buggy clients to make their bookmarks public
      storage:bookmarks:
        access_model: whitelist
  mod_push: {}
  mod_push_keepalive: {}
  mod_register:
    ## Only accept registration requests from the "trusted"
    ## network (see access_rules section above).
    ## Think twice before enabling registration from any
    ## address. See the Jabber SPAM Manifesto for details:
    ## https://github.com/ge0rg/jabber-spam-fighting-manifesto
    ip_access: trusted_network
  mod_roster:
    versioning: true
  mod_sip: {}
  mod_s2s_dialback: {}
  mod_shared_roster: {}
  mod_stream_mgmt:
    resend_on_timeout: if_offline
  mod_vcard: {}
  mod_vcard_xupdate: {}
  mod_version:
    show_os: false

### Local Variables:
### mode: yaml
### End:
### vim: set filetype=yaml tabstop=8