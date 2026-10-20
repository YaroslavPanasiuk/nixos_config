Sub CreatePresentationFromImages
    Dim sImageDir As String
    Dim sOutputFile As String
    Dim oDoc As Object
    Dim oSlide As Object
    Dim oDrawPages As Object
    Dim sImage As String
    
    ' Configure paths (update these!)
    sImageDir = "/path/to/your/images/" ' End with a slash
    sOutputFile = "/path/to/output.pptx"
    
    ' Create a new presentation
    oDoc = StarDesktop.loadComponentFromURL("private:factory/simpress", "_blank", 0, Array())
    oDrawPages = oDoc.getDrawPages()
    
    ' Loop through images in the directory
    sImage = Dir(sImageDir & "*.png") ' Supports .png, .jpg, etc.
    Do While sImage <> ""
        ' Add a new slide
        oSlide = oDrawPages.insertNewByIndex(oDrawPages.getCount())
        oSlide.Layout = 20 ' Use a blank layout (layout ID 20)
        
        ' Insert image into the slide
        InsertImageIntoSlide(oSlide, sImageDir & sImage)
        
        sImage = Dir()
    Loop
    
    ' Save as PPTX and close
    SaveAsPPTX(oDoc, sOutputFile)
    oDoc.close(True)
End Sub

Sub InsertImageIntoSlide(oSlide, sImagePath)
    Dim oShape As Object
    oShape = oSlide.createInstance("com.sun.star.drawing.GraphicObjectShape")
    oShape.GraphicURL = ConvertToURL(sImagePath)
    oShape.Anchor = com.sun.star.text.TextContentAnchorType.AT_PAGE
    oShape.Width = oSlide.Size.Width
    oShape.Height = oSlide.Size.Height
    oSlide.add(oShape)
End Sub

Sub SaveAsPPTX(oDoc, sOutputPath)
    Dim oArgs(1) As New com.sun.star.beans.PropertyValue
    oArgs(0).Name = "FilterName"
    oArgs(0).Value = "Impress MS PowerPoint 2007 XML"
    oArgs(1).Name = "Overwrite"
    oArgs(1).Value = True
    oDoc.storeToURL(ConvertToURL(sOutputPath), oArgs)
End Sub