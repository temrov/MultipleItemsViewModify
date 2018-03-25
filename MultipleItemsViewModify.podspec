Pod::Spec.new do |s|

  s.name         = "MultipleItemsViewModify"
  s.version      = "0.1.4"
  s.summary      = "MultipleItemsViewModify helps developers to modify views for displaying data arrays (UITableView or UICollectionView for example)."
  s.homepage     = "https://github.com/temrov/MultipleItemsViewModify"
  s.license               = { :type => 'MIT', :file => 'LICENSE' }
  s.author                = { "vtemnogrudov" => "vtemnogrudov@ya.ru" }
  s.platform              = :ios, '7.0'
  s.source                = { :git => "https://github.com/temrov/MultipleItemsViewModify.git", :tag => s.version.to_s }
  s.source_files          = 'Classes/*.{h,m}'
  s.public_header_files   = 'Classes/*.h'
  s.framework             = 'Foundation'
  s.requires_arc          = true

end
