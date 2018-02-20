Pod::Spec.new do |s|

  s.name         = "MultipleItemsViewModify"
  s.version      = "0.0.3"
  s.summary      = "MultipleItemsViewModify helps developers to modify views for displaying data arrays (UITableView or UICollectionView for example)."
  s.homepage     = "https://github.com/temrov/MultipleItemsViewModify"
  s.license               = { :type => 'MIT', :file => 'LICENSE' }
  s.author                = { "Username" => "username@mail.domain" }
  s.platform              = :ios, '7.0'
  s.source                = { :git => "https://github.com/temrov/MultipleItemsViewModify.git", :tag => s.version.to_s }
  s.public_header_files   = 'Classes/Protocols/*.h', 'Classes/UITableView/*.h'
  s.framework             = 'Foundation'
  s.requires_arc          = true

  s.subspec 'UITableView' do |table|
    table.source_files = 'Classes/UITableView/*.{h,m}'
    table.dependency 'Classes/Protocols'
  end
end
