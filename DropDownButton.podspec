Pod::Spec.new do |spec|

  spec.name         = 'DropDownButton'
  spec.version      = '1.0.1'
  spec.summary      = 'An easy to use drop down button'
  spec.description  = <<-DESC
                        An easy to use and customizable button which opens a drop-down menu with selectable elements.
                        DESC
  spec.module_name  = 'DropDownButton'
  spec.homepage     = 'https://github.com/lamnguynn/DropDownButton'
  spec.license      = 'MIT'
  spec.author             = { "lamnguynn" => "lance66nguyen@gmail.com" }
  spec.ios.deployment_target = "14.5"
  spec.swift_version = "5"
  spec.source       = { :git => "https://github.com/lamnguynn/DropDownButton.git", :tag => spec.version }
  spec.source_files  = "DropDownButton/**/*"

end
