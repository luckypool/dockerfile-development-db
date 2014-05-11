IMG = "test_image"

namespace :container do
  desc "build #{IMG}"
  task :build do
    sh "docker build --rm -t #{IMG} ."
  end
  
  desc "rebuild #{IMG}"
  task :rebuild do
    sh "docker build --no-cache -t #{IMG} ."
  end
  
  desc "delete #{IMG}"
  task :delete do
    sh "docker rmi #{IMG}"
  end
end

namespace :docker do
  desc "remove all stopped container"
  task :remove_stopped_container do
    sh "docker rm $(docker ps -a -q)"
  end

  desc "remove all <none> images"
  task :remove_none_image do
    sh "docker rmi $(docker images | grep '^<none>' | awk '{print $3}')"
  end
end

