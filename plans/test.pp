plan awskit::test() {
  $targets = 'localhost'

  notice($targets)

  # $test = { "a" => "b"}
  # notice ($test)
  # notice ($test['a'])

  run_plan('facts', nodes => $targets)

  $target = get_targets($targets)
  $my_facts = $target[0].facts()
  # notice($my_facts)
  $fqdn = $my_facts['networking']['fqdn']
  notice("fqdn: ${fqdn}")

  # $ip_hash = get_targets($targets).reduce({}) |$acc, $target| {
  #   $acc.merge($target.host, $target.facts()['ipaddress']
  # }

  apply($targets, _catch_errors => false, _noop => true ) {
    package { 'git': }
  }
  # apply('web_servers') {
  #   include postgresql::client
  #   class {'python':
  #     virtualenv: 'present',
  #     gunicorn: 'present' }
  #   package { 'git': }
  # }
  # run_task('my_app::install', 'web-servers')
  # run_task('my_app::healthcheck', localhost,
  #   targets => get_targets('web_servers'))
}