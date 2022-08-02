class ImagesUploader < CarrierWave::Uploader::Base
  include CarrierWave::MiniMagick
  storage :fog#:file
  def store_dir
    "assets/admin/sscool/photos"
  end

  def extension_allowlist
    %w(jpg jpeg gif png)
  end

  version :thumb do
    process resize_to_fit: [150, 104]
  end

  version :small do
    process resize_to_fit: [400, 279]
  end

  version :medium do
    process resize_to_fit: [600, -1]
  end

  version :large do
    process resize_to_fit: [1200, -1]
  end
end
