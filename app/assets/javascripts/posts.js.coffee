jQuery ->
  new CarrierWaveCropper()

class CarrierWaveCropper
  constructor: ->
    $('#post_picture_cropbox').Jcrop
      aspectRatio: 1
      setSelect: [0, 0, 200, 200]
      onSelect: @update
      onChange: @update

  update: (coords) =>
    $('#post_picture_crop_x').val(coords.x)
    $('#post_picture_crop_y').val(coords.y)
    $('#post_picture_crop_w').val(coords.w)
    $('#post_picture_crop_h').val(coords.h)
    @updatePreview(coords)

  updatePreview: (coords) =>
    $('#post_picture_previewbox').css
      width: Math.round(100/coords.w * $('#post_picture_cropbox').width()) + 'px'
      height: Math.round(100/coords.h * $('#post_picture_cropbox').height()) + 'px'
      marginLeft: '-' + Math.round(100/coords.w * coords.x) + 'px'
      marginTop: '-' + Math.round(100/coords.h * coords.y) + 'px'
