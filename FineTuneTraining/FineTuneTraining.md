## Jane's Notes for Fine-Tune Training for Tesseract 4 (on OSX)

Read this guide first: https://github.com/tesseract-ocr/tesseract/wiki/TrainingTesseract-4.00 


### 1) When installing tesseract, be sure to do the steps to build and install the training tools. (It will prompt you after ./configure):

    make training

    sudo make training-install

- You should already have tessdata (I used https://github.com/tesseract-ocr/tessdata_best)
- You'll also need langdata (I used https://github.com/tesseract-ocr/langdata_lstm. This is older and smaller and may work fine too: https://github.com/tesseract-ocr/langdata)


### 2)  Set up the file structure for training. 

The easiest way to do this it to download this repository: 

https://github.com/OCR-D/ocrd-train

From here on I'll assume you have it and commands are run from in the ocrd-train-master directory:


### 3)  For fine-tuning, modify the makefile that comes in the ocrd-train repository

I based mine off the makefile here (scroll to "I modified the makefile for ocrd-train to do fine-tuning"): 
https://groups.google.com/forum/#!searchin/tesseract-ocr/makefile%7Csort:date/tesseract-ocr/be4-rjvY2tQ/wC6DGOugCgAJ

Some additional changes are necessary:

- Change the HOME, TESSDATA and LANGDATA paths at the top for your system.

* For tessdata, I created a new folder in ocrd-train-master called tessdata_new. I copied the english eng.traineddata file I have in /usr/local/share/tessdata and put it in there. If you plan to train based on other languages you can copy those too. The reason I didn't just point it to the /usr/local/share/tessdata directory is that I'm going to be extracting and updating stuff from this eng.traineddata file later so I didn't want it to clutter up /usr/local/share/tessdata. I also put my langdata folder in ocrd-train-master. 

- Change all instances of -gt.txt to .gt.txt

- I changed to MODEL_NAME = foo and CONTINUE_FROM = eng. Later steps assume these names.

- I encountered some ascii-related problems (e.g. an error with an unrecognized character (e with accent) "UnicodeEncodeError: 'ascii' codec can't encode character u'\xe9' in position 0: ordinal not in range(128)"). To fix this I installed python 3 (pillow pip3 install pil) and changed the makefile accordingly to call python3 instead of python.

- In the combine_lang_model call, changed it to use eng, $(CONTINUE_FROM), for wordlist, numbers and punc 

See included  version of the makefile


### 4)  Create some new training data

I did this in two ways 

- i) Using Rtesseract GetBoxes I extracted very high confidence words (saving corresponding text and image files). I checked enough to think that they were trustworthy, and then created many more.
- ii) Using Rtesseract GetBoxes I extracted low confidence words with characters of interests (e.g. 3's and 8's which tend to get mixed up). I fixed them by hand, so only about 100 of them total. See sections 3-5 of wine_truth.R (attached) which is my code for creating tiff and text file pairs.  Notice the tiff files are changed to ".tif" and the corresponding text files are changed to ".gt.txt".

- All are then moved to ocrd-train-master/data/train/

- There's a way to create new training data using fonts but I didn't try it out since it's not useful for my application.


### 5) Train

    make training

- From within ocrd-train-master. 
- First builds box and .lstmf files. Terminal output should show this happening. 
- Divides the training data into a train and test set (default 90/10 split)
- Creates a merged unicharset from English and the training data
- Creates a starter .traineddata file with combine_lang_model
	could base on the eng charset with --input_unicharset langdata_lstm-master/eng/eng.unicharset
	if for some reason you wanted to bypass creating a merged unicharset
- Trains the model with lstmtraining
	checkpoints go to data/checkpoints. foo checkpoint names show character error and iteration
        there's a flag to congrol the iteratons --max_iterations 1000
- Turn the model into a final model with lstmtraining --stop_training
	Output is data/foo.traineddata - check the size it should be slightly larger than the eng.traineddata file it was built off


### 6)  test out the model to see if more iterations can be helpful without overfitting

    sh jane/janetrain.sh 

calls lstmeval for english and foo w/ training and testing data, e.g.

    lstmeval --model ~/Documents/DSI/ocrd-train-master/data/foo.traineddata --eval_listfile data/list.eval

### 7) Continue training?

    lstmtraining --continue_from data/checkpoints	--old_traineddata tessdata_new/eng.traineddata 	--traineddata data/foo/foo.traineddata    --model_output data/checkpoints/foo  --debug_interval 0 	--train_listfile data/list.train --eval_listfile data/list.eval --sequential_training --max_iterations 1000

set --debug_interval -1 for more verbose training

Can also continue from an .lstm file.
	.lstm can be extracted from .traineddata with combine_tessdata -e, e.g. 
	(See doc file for combine_tessdata in tesseract/doc)
        combine_tessdata -e tessdata_new/eng.traineddata tessdata_new/eng.lstm

You can see what files are in a .traineddata file with combine_tessdata -d, e.g.
        combine_tessdata -d tessdata_new/eng.traineddata


### 8) When done training, make finished model (data/foo.traineddata)

lstmtraining --stop_training --continue_from data/checkpoints/foo_checkpoint --old_traineddata tessdata_new/eng.traineddata  --traineddata data/foo/foo.traineddata --model_output data/foo.traineddata

 - test again, 

        sh jane/janetrain.sh


### 9)  Add foo.trainneddata to tesseract languages, e.g.

sudo cp data/foo.traineddata /usr/local/share/tessdata/foo.traineddata


### 10)  Test and compare

sh jane/janetest.sh calls tesseract from the command line and diff

E.g., 

Test

    tesseract ~/Documents/DSI/OCR_SherryLehmann/Sample/Sample18/UCD_Lehmann_0040.jpg ~/Desktop/test40foo --oem 1 -l foo
    tesseract ~/Documents/DSI/OCR_SherryLehmann/Sample/Sample18/UCD_Lehmann_0040.jpg ~/Desktop/test40eng --oem 1 -l eng

Compare

    diff ~/Desktop/test40eng.txt ~/Desktop/test40foo.txt > ~/Desktop/eng_foo40


END)

To start again from scratch:
    
    make clean 

from in ocrd-train-master, to clear out generated files in the data folder, e.g. box files and checkpoint (see bottom of the makefile). Only thing left is the training .tif gt.txt files


-----

Included files:

Makefile - My modified version
wine_truth.R - Used to make .tx.txt and .tif pairs (see sections 3-5)
sample_train.zip - A few .gt.txt  and .tif files pairs to try it out before investing time
janetrain.sh - quick check for under/overfitting
janetest.sh - quick check of results
