require "docker_helper"

### DOCKER_IMAGE ###############################################################

describe "Docker image", :test => :docker_image do
  # Default Serverspec backend
  before(:each) { set :backend, :docker }

  ### DOCKER_IMAGE #############################################################

  describe docker_image(ENV["DOCKER_IMAGE"]) do
    # Execute Serverspec command locally
    before(:each) { set :backend, :exec }
    it { is_expected.to exist }
  end

  ### PACKAGES #################################################################

  describe "Packages" do
    [
      # [package,                   version,                    installer]
      ["clamav",                    ENV["CLAMAV_VERSION"]],
      ["clamav-daemon",             ENV["CLAMAV_VERSION"]],
      ["clamav-libunrar",           ENV["CLAMAV_VERSION"]],
      ["freshclam",                 ENV["CLAMAV_VERSION"]],
    ].each do |package, version, installer|
      describe package(package) do
        it { is_expected.to be_installed }                        if installer.nil? && version.nil?
        it { is_expected.to be_installed.with_version(version) }  if installer.nil? && ! version.nil?
        it { is_expected.to be_installed.by(installer) }          if ! installer.nil? && version.nil?
        it { is_expected.to be_installed.by(installer).with_version(version) } if ! installer.nil? && ! version.nil?
      end
    end
  end

  ### FILES ####################################################################

  describe "Files" do
    [
      # [file,                                            mode, user,       group,      [expectations]]
      ["/docker-entrypoint.sh",                           755, "root",      "root",     [:be_file]],
      ["/docker-entrypoint.d/30-clamav-environment.sh",   644, "root",      "root",     [:be_file, :eq_sha256sum]],
      ["/docker-entrypoint.d/50-clamav-freshclam.sh",     644, "root",      "root",     [:be_file, :eq_sha256sum]],
      ["/etc/clamav/clamd.conf",                          644, "root",      "root",     [:be_file, :eq_sha256sum]],
      ["/etc/clamav/freshclam.conf",                      644, "root",      "root",     [:be_file, :eq_sha256sum]],
      ["/var/lib/clamav",                                 755, "clamav",    "clamav",   [:be_directory]],
      ["/var/lib/clamav/main.cvd",                        644, "clamav",    "clamav",   [:be_file]],
      ["/var/lib/clamav/daily.cvd",                       644, "clamav",    "clamav",   [:be_file]],
      ["/var/lib/clamav/bytecode.cvd",                    644, "clamav",    "clamav",   [:be_file]],
      ["/var/lib/clamav/clamd.socket",                    666, "clamav",    "clamav",   [:be_socket]],
      ["/var/log/clamav",                                 755, "clamav",    "clamav",   [:be_directory]],
    ].each do |file, mode, user, group, expectations|
      expectations ||= []
      context file(file) do
        it { is_expected.to exist }
        it { is_expected.to be_file }       if expectations.include?(:be_file)
        it { is_expected.to be_socket }     if expectations.include?(:be_socket)
        it { is_expected.to be_directory }  if expectations.include?(:be_directory)
        it { is_expected.to be_mode(mode) } unless mode.nil?
        it { is_expected.to be_owned_by(user) } unless user.nil?
        it { is_expected.to be_grouped_into(group) } unless group.nil?
        its(:sha256sum) do
          is_expected.to eq(
              Digest::SHA256.file("rootfs/#{subject.name}").to_s
          )
        end if expectations.include?(:eq_sha256sum)
      end
    end
  end

  ##############################################################################

end

################################################################################
