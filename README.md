# CarrierWave installation and setup
To use the optional integration module for uploading images with ActiveRecord or Mongoid using CarrierWave, install the CarrierWave GEM:

```
gem 'carrierwave'
gem 'imagekit', github: 'imagekit-developer/imagekit-gem'
```

`Note: The CarrierWave GEM should be loaded before the Imagekit GEM.`

# Upload examples
Below is a short example that demonstrates using Imagekit with CarrierWave in your Rails project. In this example, we use the Product model entity to support attaching an image to each product. Attached images are managed by the 'picture' attribute (column) of the Product entity.

To get started, first define a CarrierWave uploader class and tell it to use the Imagekit plugin. For details, see the [CarrierWave documentation](https://github.com/carrierwaveuploader/carrierwave).

In this example, we'll convert the uploaded image to a PNG before storing it in the imagekit cloud. We define additional transformations required for displaying the image in our site: 'cropped' and 'rotated'. A randomly generated unique Public ID is generated for each uploaded image and persistently stored in the model. You can pass as many as paremeters defined in the imagekit documentation.
```
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
end
```

In the following example, we explicitly define a publicid based on the content of the 'name' attribute of the 'Product' entity.
```
class PictureUploader < CarrierWave::Uploader::Base
  include Imagekit::CarrierWave
  
  ...
  ...
  ...

  def public_id
    return model.name
  end
end
```

The 'picture' attribute of Product is simply a String (a DB migration script is needed of course). We mount it to the 'PictureUploader' class we've just defined in the app/uploaders/ directory:
```
class Product < ApplicationRecord
  ...
  mount_uploader :picture, PictureUploader
  ...
end
```

In our HTML form for Product adding/editing, we add a File field for uploading the picture.
```
  <%= form_for @product do |form| %>
    <%= form.file_field :picture %>
  <% end %>
```

Now you can use standard image_tag calls for displaying the uploaded images and their derived transformations and the Imagekit GEM automatically generates the correct full URL for accessing your resources:
```
  <%= image_tag(product.picture.cropped.url) %>
  or
  <%= image_tag(product.picture.url(:cropped)) %>
```

