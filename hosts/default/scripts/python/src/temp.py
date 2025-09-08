#!/usr/bin/env python3
import uno
from com.sun.star.beans import PropertyValue
from com.sun.star.awt import Size

# === CONFIGURATION ===
INPUT_FILE  = "/home/yaroslaw/Downloads/Пісні 05.09.2025 (онлайн).pptx"
OUTPUT_FILE = "/home/yaroslaw/Downloads/Пісні 05.09.2025 (онлайн) edited.pptx"

# New slide size in cm (LibreOffice units = 1/100 mm)
NEW_WIDTH_CM  = 50.8
NEW_HEIGHT_CM = 28.575

# Font scaling factor (e.g. 1.5 = 48pt → 72pt)
FONT_SCALE = 1.5

# =====================

def cm_to_hmm(cm):
    """Convert cm to 1/100 mm (LibreOffice internal units)."""
    return int(cm * 1000)

def main():
    # Connect to running LibreOffice instance
    local_ctx = uno.getComponentContext()
    resolver = local_ctx.ServiceManager.createInstanceWithContext(
        "com.sun.star.bridge.UnoUrlResolver", local_ctx)
    ctx = resolver.resolve("uno:socket,host=localhost,port=2002;urp;StarOffice.ComponentContext")

    smgr = ctx.ServiceManager
    desktop = smgr.createInstanceWithContext("com.sun.star.frame.Desktop", ctx)

    # Load the presentation
    inProps = [PropertyValue(Name="Hidden", Value=True)]
    doc = desktop.loadComponentFromURL(
        uno.systemPathToFileUrl(INPUT_FILE), "_blank", 0, inProps)

    # Get page layout
    pages = doc.getDrawPages()
    first_page = pages.getByIndex(0)
    old_size = first_page.getSize()

    old_width  = old_size.Width
    old_height = old_size.Height

    new_width  = cm_to_hmm(NEW_WIDTH_CM)
    new_height = cm_to_hmm(NEW_HEIGHT_CM)

    # Scale factors
    scale_x = new_width / old_width
    scale_y = new_height / old_height

    print(f"Scaling objects by X={scale_x:.3f}, Y={scale_y:.3f}")

    # Update all slide sizes and scale shapes
    for i in range(pages.getCount()):
        page = pages.getByIndex(i)

        # Set new page size
        page.setSize(Size(new_width, new_height))

        # Scale each shape
        for j in range(page.getCount()):
            shape = page.getByIndex(j)

            # Scale position
            shape.setPosition(uno.createUnoStruct(
                "com.sun.star.awt.Point",
                int(shape.getPosition().X * scale_x),
                int(shape.getPosition().Y * scale_y)
            ))

            # Scale size
            shape.setSize(Size(
                int(shape.getSize().Width * scale_x),
                int(shape.getSize().Height * scale_y)
            ))

            # If it's a text shape: scale font size and widen
            if shape.supportsService("com.sun.star.drawing.TextShape"):
                text = shape.getText()
                cursor = text.createTextCursor()
                try:
                    size = cursor.CharHeight
                    cursor.CharHeight = size * FONT_SCALE
                    # also widen text box a bit
                    s = shape.getSize()
                    shape.setSize(Size(int(s.Width * FONT_SCALE), s.Height))
                except Exception:
                    pass

    # Save the document
    outProps = [PropertyValue(Name="FilterName", Value="Impress MS PowerPoint 2007 XML")]
    doc.storeToURL(uno.systemPathToFileUrl(OUTPUT_FILE), outProps)

    doc.close(True)
    print(f"✅ Saved updated presentation to {OUTPUT_FILE}")

if __name__ == "__main__":
    main()
