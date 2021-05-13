mkdir val
cd val
tar xf /home/dataset/image-net/ILSVRC2012_img_val.tar
wget https://raw.githubusercontent.com/soumith/imagenetloader.torch/master/valprep.sh
bash valprep.sh
rm valprep.sh

