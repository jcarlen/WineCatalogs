# test english model on new training set

lstmeval --model ~/Documents/DSI/ocrd-train-master/tessdata_new/eng.lstm --traineddata /usr/local/share/tessdata/eng.traineddata --eval_listfile data/list.train 2>&1 |  grep iteration* >> janetrain.txt

# test foo model on new training set (should perform best)
#lstmeval --model ~/Documents/DSI/ocrd-train-master/data/checkpoints/foo_checkpoint  --traineddata /usr/local/share/tessdata/eng.traineddata --eval_listfile data/list.train 2>&1 |  grep iteration* >> janetrain.txt

lstmeval --model ~/Documents/DSI/ocrd-train-master/data/foo.traineddata --eval_listfile data/list.train 2>&1 |  grep iteration* >> janetrain.txt

# test english model on eval set (should perform same as on testing set)
lstmeval --model ~/Documents/DSI/ocrd-train-master/tessdata_new/eng.lstm --traineddata /usr/local/share/tessdata/eng.traineddata --eval_listfile data/list.eval 2>&1 |  grep iteration* >> janetrain.txt

# test foo model on new eval set (?)
#lstmeval --model ~/Documents/DSI/ocrd-train-master/data/checkpoints/foo_checkpoint  --traineddata /usr/local/share/tessdata/eng.traineddata --eval_listfile data/list.eval 2>&1 |  grep iteration* >> janetrain.txt

lstmeval --model ~/Documents/DSI/ocrd-train-master/data/foo.traineddata --eval_listfile data/list.eval 2>&1 |  grep iteration* >> janetrain.txt

