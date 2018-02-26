# devhops::create_master
#
# Provision a Puppetmaster in AWS
#
# @summary Provision a Puppetmaster in AWS
#
# @example
#   include devhops::create_master
class devhops::create_master (
  $instance_type,
  #$pm_ami,
) {

  include devhops

  $pm_ami = $devhops::pm_ami

  Ec2_instance {
    region            => $devhops::region,
    availability_zone => $devhops::availability_zone,
    key_name          => $devhops::key_name,
  }

  ec2_securitygroup { 'devhops-master':
    ensure      => 'present',
    region      => $devhops::region,
    vpc         => $devhops::vpc,
    description => 'SG for DevHops Master',
    ingress     => [
      { protocol => 'tcp',  port => 22,        cidr => '0.0.0.0/0', },
      { protocol => 'tcp',  port => 443,       cidr => '0.0.0.0/0', },
      { protocol => 'tcp',  port => 3000,      cidr => '0.0.0.0/0', },
      { protocol => 'tcp',  port => 8140,      cidr => '0.0.0.0/0', },
      { protocol => 'tcp',  port => 8142,      cidr => '0.0.0.0/0', },
      { protocol => 'tcp',  port => 8143,      cidr => '0.0.0.0/0', },
      { protocol => 'tcp',  port => 8170,      cidr => '0.0.0.0/0', },
      { protocol => 'tcp',  port => 61613,     cidr => '0.0.0.0/0', },
      { protocol => 'icmp',                    cidr => '0.0.0.0/0', },
    ],
  }

  # puppetmaster
  ec2_instance { 'pm-devhops':
    ensure          => running,
    image_id        => $pm_ami,
    instance_type   => $instance_type,
    subnet          => $devhops::subnet,
    security_groups => ['devhops-master'],
    tags            => $devhops::tags,
    require         => Ec2_securitygroup['devhops-master'],
  }

  ec2_elastic_ip { $devhops::master_ip:
    ensure   => 'attached',
    instance => 'pm-devhops',
    region   => $devhops::region,
  }

}
