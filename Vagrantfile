Vagrant.configure("2") do |config|
  config.vm.provider "docker" do |d|
     d.vagrant_vagrantfile = "#{ENV['COREOS_DIR'] || "../coreos-vagrant"}/Vagrantfile"
     d.vagrant_machine = "core-01"
  end

  config.vm.define "steam_base" do |app|
    app.vm.provider "docker" do |d|
      d.build_dir = "./"
      d.name =  "steam_base"
    end
  end
end
