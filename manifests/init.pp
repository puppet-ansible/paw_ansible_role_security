# paw_ansible_role_security
# @summary Manage paw_ansible_role_security configuration
#
# @param security_autoupdate_reboot Autoupdate mail settings used on Debian/Ubuntu only.
# @param security_autoupdate_reboot_time
# @param security_autoupdate_mail_to
# @param origin
# @param package
# @param security_ssh_port
# @param security_ssh_password_authentication
# @param security_ssh_permit_root_login
# @param security_ssh_usedns
# @param security_ssh_permit_empty_password
# @param security_ssh_challenge_response_auth
# @param security_ssh_gss_api_authentication
# @param security_ssh_x11_forwarding
# @param security_sshd_state
# @param security_ssh_restart_handler_state
# @param security_ssh_allowed_users
# @param security_ssh_allowed_groups
# @param security_sudoers_passwordless
# @param security_sudoers_passworded
# @param security_autoupdate_enabled
# @param security_autoupdate_blacklist
# @param security_autoupdate_additional_origins
# @param security_autoupdate_mail_on_error
# @param security_fail2ban_enabled
# @param security_fail2ban_custom_configuration_template
# @param par_tags An array of Ansible tags to execute (optional)
# @param par_skip_tags An array of Ansible tags to skip (optional)
# @param par_start_at_task The name of the task to start execution at (optional)
# @param par_limit Limit playbook execution to specific hosts (optional)
# @param par_verbose Enable verbose output from Ansible (optional)
# @param par_check_mode Run Ansible in check mode (dry-run) (optional)
# @param par_timeout Timeout in seconds for playbook execution (optional)
# @param par_user Remote user to use for Ansible connections (optional)
# @param par_env_vars Additional environment variables for ansible-playbook execution (optional)
# @param par_logoutput Control whether playbook output is displayed in Puppet logs (optional)
# @param par_exclusive Serialize playbook execution using a lock file (optional)
class paw_ansible_role_security (
  String $security_autoupdate_reboot = 'false',
  String $security_autoupdate_reboot_time = '03:00',
  Optional[String] $security_autoupdate_mail_to = undef,
  Optional[String] $origin = undef,
  Optional[String] $package = undef,
  Integer $security_ssh_port = 22,
  String $security_ssh_password_authentication = 'no',
  String $security_ssh_permit_root_login = 'no',
  String $security_ssh_usedns = 'no',
  String $security_ssh_permit_empty_password = 'no',
  String $security_ssh_challenge_response_auth = 'no',
  String $security_ssh_gss_api_authentication = 'no',
  String $security_ssh_x11_forwarding = 'no',
  String $security_sshd_state = 'started',
  String $security_ssh_restart_handler_state = 'restarted',
  Array $security_ssh_allowed_users = [],
  Array $security_ssh_allowed_groups = [],
  Array $security_sudoers_passwordless = [],
  Array $security_sudoers_passworded = [],
  Boolean $security_autoupdate_enabled = true,
  Array $security_autoupdate_blacklist = [],
  Array $security_autoupdate_additional_origins = [],
  Boolean $security_autoupdate_mail_on_error = true,
  Boolean $security_fail2ban_enabled = true,
  String $security_fail2ban_custom_configuration_template = 'jail.local.j2',
  Optional[Array[String]] $par_tags = undef,
  Optional[Array[String]] $par_skip_tags = undef,
  Optional[String] $par_start_at_task = undef,
  Optional[String] $par_limit = undef,
  Optional[Boolean] $par_verbose = undef,
  Optional[Boolean] $par_check_mode = undef,
  Optional[Integer] $par_timeout = undef,
  Optional[String] $par_user = undef,
  Optional[Hash] $par_env_vars = undef,
  Optional[Boolean] $par_logoutput = undef,
  Optional[Boolean] $par_exclusive = undef
) {
# Execute the Ansible role using PAR (Puppet Ansible Runner)
  $vardir = $facts['puppet_vardir'] ? {
    undef   => $settings::vardir ? {
      undef   => '/opt/puppetlabs/puppet/cache',
      default => $settings::vardir,
    },
    default => $facts['puppet_vardir'],
  }
  $playbook_path = "${vardir}/lib/puppet_x/ansible_modules/ansible_role_security/playbook.yml"

  par { 'paw_ansible_role_security-main':
    ensure        => present,
    playbook      => $playbook_path,
    playbook_vars => {
      'security_autoupdate_reboot'                      => $security_autoupdate_reboot,
      'security_autoupdate_reboot_time'                 => $security_autoupdate_reboot_time,
      'security_autoupdate_mail_to'                     => $security_autoupdate_mail_to,
      'origin'                                          => $origin,
      'package'                                         => $package,
      'security_ssh_port'                               => $security_ssh_port,
      'security_ssh_password_authentication'            => $security_ssh_password_authentication,
      'security_ssh_permit_root_login'                  => $security_ssh_permit_root_login,
      'security_ssh_usedns'                             => $security_ssh_usedns,
      'security_ssh_permit_empty_password'              => $security_ssh_permit_empty_password,
      'security_ssh_challenge_response_auth'            => $security_ssh_challenge_response_auth,
      'security_ssh_gss_api_authentication'             => $security_ssh_gss_api_authentication,
      'security_ssh_x11_forwarding'                     => $security_ssh_x11_forwarding,
      'security_sshd_state'                             => $security_sshd_state,
      'security_ssh_restart_handler_state'              => $security_ssh_restart_handler_state,
      'security_ssh_allowed_users'                      => $security_ssh_allowed_users,
      'security_ssh_allowed_groups'                     => $security_ssh_allowed_groups,
      'security_sudoers_passwordless'                   => $security_sudoers_passwordless,
      'security_sudoers_passworded'                     => $security_sudoers_passworded,
      'security_autoupdate_enabled'                     => $security_autoupdate_enabled,
      'security_autoupdate_blacklist'                   => $security_autoupdate_blacklist,
      'security_autoupdate_additional_origins'          => $security_autoupdate_additional_origins,
      'security_autoupdate_mail_on_error'               => $security_autoupdate_mail_on_error,
      'security_fail2ban_enabled'                       => $security_fail2ban_enabled,
      'security_fail2ban_custom_configuration_template' => $security_fail2ban_custom_configuration_template,
    },
    tags          => $par_tags,
    skip_tags     => $par_skip_tags,
    start_at_task => $par_start_at_task,
    limit         => $par_limit,
    verbose       => $par_verbose,
    check_mode    => $par_check_mode,
    timeout       => $par_timeout,
    user          => $par_user,
    env_vars      => $par_env_vars,
    logoutput     => $par_logoutput,
    exclusive     => $par_exclusive,
  }
}
