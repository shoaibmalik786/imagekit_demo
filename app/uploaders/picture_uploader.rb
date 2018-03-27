class PictureUploader < CarrierWave::Uploader::Base
  include Imagekit::CarrierWave
 
  # Generate a 164x164 JPG of 80% quality 
  # Possible cropping options are as following :
  # maintain_ratio -> resize_to_limit, resize_to_fill or crop
  # force          -> resize_to_fit
  # at_max         -> resize_and_pad
  # at_least       -> scale
  ## You can pass all possible transformations in the transformation hash.
  version :cropped do
    process resize_to_fill: [164, 164]
    process convert: 'jpg'
    imagekit_transformation transformation: { quality: 80, rotate: 90 }
  end
  # You can access the url like product.picture.cropped.url or product.picture.url(:cropped)



  ## You can use standalone transformation options as in the example below
  # Rotate an image to 90 degree.
  version :rotated do
    imagekit_transformation transformation: { rotate: 90 }
  end
  # You can access the url like product.picture.rotated.url or product.picture.url(:rotated)


  def public_id
    return model.name
  end

end
