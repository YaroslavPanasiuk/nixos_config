(define (script-fu-resize-and-blur-background-headless in-file out-file in-new-width in-new-height)
  ;; Load image in headless mode
  (let* (
        (image (car (gimp-file-load RUN-NONINTERACTIVE in-file in-file)))
        (drawable (car (gimp-image-get-active-layer image)))
        (original-width (car (gimp-image-width image)))
        (original-height (car (gimp-image-height image)))
        (original-width-height-ratio (/ original-width original-height))
        (new-width-height-ratio (/ in-new-width in-new-height))
  ) 
  (gimp-image-undo-group-start image)

  ;; Step 1: Resize the image
  (if (> original-width-height-ratio new-width-height-ratio)
    (begin
      (let* (
            (new-width in-new-width)
            (new-height (* (/ original-height original-width) new-width))
          )
            
        (gimp-layer-add-alpha (car (gimp-image-get-active-layer image)))
        (gimp-image-scale image new-width new-height)
        (gimp-image-resize image in-new-width in-new-height 0 (/ (- in-new-height new-height) 2)) ; Center horizontally
      )
    )
    (begin
      (let* (
            (original-width (car (gimp-image-width image)))
            (original-height (car (gimp-image-height image)))
            (new-height in-new-height)
            (new-width (* (/ original-width original-height) new-height))
          )
            
        (gimp-layer-add-alpha (car (gimp-image-get-active-layer image)))
        (gimp-image-scale image new-width new-height)
        (gimp-image-resize image in-new-width in-new-height (/ (- in-new-width new-width) 2) 0) ; Center horizontally
      )
    )
  )

  ;; Step 2: Create background layer
  (let* (
        (background-layer (car (gimp-layer-new-from-drawable drawable image)))
      )
    (gimp-layer-set-name background-layer "Background")
    (gimp-image-insert-layer image background-layer 0 -1) ; Add to bottom
    (gimp-layer-resize-to-image-size background-layer) ; Fill entire canvas
  )

  ;; Step 3: Scale background layer
  (if (> original-width-height-ratio new-width-height-ratio)
    (begin
      (let* (
            (original-height (car (gimp-drawable-height drawable)))
            (background-layer (car (gimp-image-get-layer-by-name image "Background")))
            (new-height in-new-height)
            (new-width (* (/ in-new-width original-height) new-height))
            )
        (gimp-layer-scale background-layer new-width new-height TRUE)
      )
    )
    (begin
      (let* (
            (original-width (car (gimp-drawable-width drawable)))
            (background-layer (car (gimp-image-get-layer-by-name image "Background")))
            (new-width in-new-width)
            (new-height (* (/ in-new-height original-width) new-width))
            )
        (gimp-layer-scale background-layer new-width new-height TRUE)
      )
    )
  )


  ;; Step 4: Apply blur
  (let* (
        (background-layer (car (gimp-image-get-layer-by-name image "Background")))
      )
    (plug-in-gauss RUN-NONINTERACTIVE image background-layer 30 30 0) ; Blur radius
  )

  ;; Save and clean up
  (gimp-image-undo-group-end image)
  (gimp-file-save RUN-NONINTERACTIVE image (car (gimp-image-flatten image)) out-file out-file)
  (gimp-image-delete image)
))

;; Register with file parameters
(script-fu-register
  "script-fu-resize-and-blur-background-headless"
  "Resize and blur (Headless)"
  "Resizes image with blurred background - headless version"
  "Your Name"
  "Copyright"
  "2023"
  ""
  SF-STRING "Input File"  "/path/to/input.jpg"
  SF-STRING "Output File" "/path/to/output.jpg"
  SF-VALUE  "New Width"   "1920"
  SF-VALUE  "New Height"  "1080"
)