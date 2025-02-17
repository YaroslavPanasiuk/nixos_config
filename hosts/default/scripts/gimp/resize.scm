(define (script-fu-resize-and-blur-background image drawable in-new-width in-new-height)
  (gimp-image-undo-group-start image)

  ;; Step 1: Resize the image to a height of in-new-height, keeping aspect ratio
  (let* (
        (original-width (car (gimp-image-width image)))
        (original-height (car (gimp-image-height image)))
        (new-height in-new-height)
        (new-width (* (/ original-width original-height) new-height))
        (off-x (- 960 (* (/ original-width original-height) 540)))
        )
        
    (gimp-image-scale image new-width new-height)
    (gimp-image-resize image in-new-width in-new-height off-x 0)
  )

  ;; Step 2: Add the original image as a background layer
  (let* (
        (background-layer (car (gimp-layer-new-from-drawable drawable image))))
    (gimp-layer-set-name background-layer "Background")
    (gimp-image-insert-layer image background-layer 0 1) ; Add to the bottom of the layer stack
  )

  ;; Step 3: Resize the background layer to in-new-widthxin-new-height
  (let* (
        (original-width (car (gimp-drawable-width drawable)))
=       (background-layer (car (gimp-image-get-layer-by-name image "Background")))
        (new-width in-new-width)
        (new-height (* (/ in-new-height original-width) new-width))
        )
    (gimp-layer-scale background-layer in-new-width new-height TRUE)
  )

  ;; Step 4: Apply Gaussian blur to the background layer
  (let* (
        (background-layer (car (gimp-image-get-layer-by-name image "Background"))))
    (plug-in-gauss 1 image background-layer 30 30 0) ; Adjust blur radius as needed
  )

  (gimp-image-undo-group-end image)
  (gimp-displays-flush)

)
(script-fu-register
"script-fu-resize-and-blur-background"
"Resize and blur"
"Resizes the image"
"Yarko Panas"
"Yarko Panas"
"2025"
"*"                                      
SF-IMAGE "Image" 0
SF-DRAWABLE "Drawable" 0
SF-VALUE "New Width" "1920" ;
SF-VALUE "New Height" "1080" ;
)
(script-fu-menu-register "script-fu-resize-and-blur-background" "<Image>/Filters/Custom")
    