#One used in training (overestimates performance)
tesseract ~/Documents/DSI/OCR_SherryLehmann/Sample/Sample18/UCD_Lehmann_0040.jpg ~/Desktop/test40foo --oem 1 -l foo
tesseract ~/Documents/DSI/OCR_SherryLehmann/Sample/Sample18/UCD_Lehmann_0040.jpg ~/Desktop/test40eng --oem 1 -l eng
tesseract ~/Documents/DSI/OCR_SherryLehmann/Sample/Sample18/UCD_Lehmann_0040.jpg ~/Desktop/test40engfoo --oem 1 -l eng+foo 
#multiple langs: https://github.com/tesseract-ocr/tesseract/wiki/Command-Line-Usage

#One outside it
tesseract ~/Documents/DSI/OCR_SherryLehmann/Sample/Sample34/UCD_Lehmann_0913.jpg ~/Desktop/test913foo --oem 1 -l foo
tesseract ~/Documents/DSI/OCR_SherryLehmann/Sample/Sample34/UCD_Lehmann_0913.jpg ~/Desktop/test913eng --oem 1 -l eng
tesseract ~/Documents/DSI/OCR_SherryLehmann/Sample/Sample34/UCD_Lehmann_0913.jpg ~/Desktop/test913engfoo --oem 1 -l eng+foo 

#Compare
diff ~/Desktop/test40eng.txt ~/Desktop/test40foo.txt > ~/Desktop/eng_foo40
diff ~/Desktop/test40eng.txt ~/Desktop/test40engfoo.txt > ~/Desktop/eng_engfoo40
diff ~/Desktop/test40foo.txt ~/Desktop/test40engfoo.txt > ~/Desktop/foo_engfoo40

diff ~/Desktop/test913eng.txt ~/Desktop/test913foo.txt > ~/Desktop/eng_foo913
diff ~/Desktop/test913eng.txt ~/Desktop/test913engfoo.txt > ~/Desktop/eng_engfoo913
diff ~/Desktop/test913foo.txt ~/Desktop/test913engfoo.txt > ~/Desktop/foo_engfoo913

