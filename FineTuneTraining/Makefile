SHELL := /bin/bash
LOCAL := $(PWD)/usr
PATH := $(LOCAL)/bin:$(PATH)
HOME := /Users/janecarlen
TESSDATA = $(HOME)/Documents/DSI/ocrd-train-master/tessdata_new
LANGDATA = $(HOME)/Documents/DSI/ocrd-train-master/langdata_lstm-master

# Name of the model to be built
MODEL_NAME = foo

# Name of the model to continue from
CONTINUE_FROM = eng

# Normalization Mode - see src/training/language_specific.sh for details 
NORM_MODE = 2

# Train directory
TRAIN := data/train

# BEGIN-EVAL makefile-parser --make-help Makefile

help:
	@echo ""
	@echo "  Targets"
	@echo ""
	@echo "    unicharset       Create unicharset"
	@echo "    lists            Create lists of lstmf filenames for training and eval"
	@echo "    training         Start training"
	@echo "    proto-model      Build the proto model"
	@echo "    leptonica        Build leptonica"
	@echo "    tesseract        Build tesseract"
	@echo "    tesseract-langs  Download tesseract-langs"
	@echo "    langdata         Download langdata"
	@echo "    clean            Clean all generated files"
	@echo ""
	@echo "  Variables"
	@echo ""
	@echo "    MODEL_NAME         Name of the model to be built"
	@echo "    CORES              No of cores to use for compiling leptonica/tesseract"
	@echo "    TESSERACT_VERSION  Tesseract commit. Default: $(TESSERACT_VERSION)"
	@echo "    LANGDATA_VERSION   Tesseract langdata version. Default: $(LANGDATA_VERSION)"
	@echo "    TRAIN              Train directory"
	@echo "    RATIO_TRAIN        Ratio of train / eval training data"

# END-EVAL

# Ratio of train / eval training data
RATIO_TRAIN := 0.90

ALL_BOXES = data/all-boxes
ALL_LSTMF = data/all-lstmf

# Create unicharset
unicharset: data/unicharset

# Create lists of lstmf filenames for training and eval
lists: $(ALL_LSTMF) data/list.train data/list.eval

data/list.train: $(ALL_LSTMF)
	total=`cat $(ALL_LSTMF) | wc -l` \
	   no=`echo "$$total * $(RATIO_TRAIN) / 1" | bc`; \
	   head -n "$$no" $(ALL_LSTMF) > "$@"

data/list.eval: $(ALL_LSTMF)
	total=`cat $(ALL_LSTMF) | wc -l` \
	   no=`echo "($$total - $$total * $(RATIO_TRAIN)) / 1" | bc`; \
	   tail -n "+$$no" $(ALL_LSTMF) > "$@"

# Start training
training: data/$(MODEL_NAME).traineddata

data/unicharset: $(ALL_BOXES)
	combine_tessdata -u $(TESSDATA)/$(CONTINUE_FROM).traineddata  $(TESSDATA)/$(CONTINUE_FROM).
	unicharset_extractor --output_unicharset "$(TRAIN)/my.unicharset" --norm_mode $(NORM_MODE) "$(ALL_BOXES)"
	merge_unicharsets $(TESSDATA)/$(CONTINUE_FROM).lstm-unicharset $(TRAIN)/my.unicharset  "$@"
	
$(ALL_BOXES): $(sort $(patsubst %.tif,%.box,$(wildcard $(TRAIN)/*.tif)))
	find $(TRAIN) -name '*.box' -exec cat {} \; > "$@"
	
$(TRAIN)/%.box: $(TRAIN)/%.tif $(TRAIN)/%.gt.txt
	python3 generate_line_box.py -i "$(TRAIN)/$*.tif" -t "$(TRAIN)/$*.gt.txt" > "$@"

$(ALL_LSTMF): $(sort $(patsubst %.tif,%.lstmf,$(wildcard $(TRAIN)/*.tif)))
	find $(TRAIN) -name '*.lstmf' -exec echo {} \; | sort -R -o "$@"

$(TRAIN)/%.lstmf: $(TRAIN)/%.box
	tesseract $(TRAIN)/$*.tif $(TRAIN)/$*   --psm 6 lstm.train

# Build the proto model
proto-model: data/$(MODEL_NAME)/$(MODEL_NAME).traineddata

data/$(MODEL_NAME)/$(MODEL_NAME).traineddata: $(LANGDATA) data/unicharset
	combine_lang_model \
	  --input_unicharset data/unicharset \
	  --script_dir $(LANGDATA) \
	  --words $(LANGDATA)/$(CONTINUE_FROM)/$(CONTINUE_FROM).wordlist \
	  --numbers $(LANGDATA)/$(CONTINUE_FROM)/$(CONTINUE_FROM).numbers \
	  --puncs $(LANGDATA)/$(CONTINUE_FROM)/$(CONTINUE_FROM).punc \
	  --output_dir data/ \
	  --lang $(MODEL_NAME)

data/checkpoints/$(MODEL_NAME)_checkpoint: unicharset lists proto-model
	mkdir -p data/checkpoints
	lstmtraining \
	  --continue_from   $(TESSDATA)/$(CONTINUE_FROM).lstm \
	  --old_traineddata $(TESSDATA)/$(CONTINUE_FROM).traineddata \
	  --traineddata data/$(MODEL_NAME)/$(MODEL_NAME).traineddata \
	  --model_output data/checkpoints/$(MODEL_NAME) \
	  --debug_interval 0 \
	  --train_listfile data/list.train \
	  --eval_listfile data/list.eval \
	  --sequential_training \
	  --max_iterations 1000

data/$(MODEL_NAME).traineddata: data/checkpoints/$(MODEL_NAME)_checkpoint
	lstmtraining \
	--stop_training \
	--continue_from $^ \
	--old_traineddata $(TESSDATA)/$(CONTINUE_FROM).traineddata \
	--traineddata data/$(MODEL_NAME)/$(MODEL_NAME).traineddata \
	--model_output $@

# Clean all generated files
clean:
	find data/train -name '*.box' -delete
	find data/train -name '*.lstmf' -delete
	rm -rf data/all-*
	rm -rf data/list.*
	rm -rf data/$(MODEL_NAME)
	rm -rf data/unicharset
	rm -rf data/checkpoints

# Clean all but the box and lstmf files -- I added this for easier experimenting
clean2:
	rm -rf data/all-*
	rm -rf data/list.*
	rm -rf data/$(MODEL_NAME)
	rm -rf data/unicharset
	rm -rf data/checkpoints
