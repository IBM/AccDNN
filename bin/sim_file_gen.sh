if [ -d ./sim/src ]; then
  rm -rf ./sim/src
fi

mkdir ./sim/src

vivado -mode batch -source ./build/ips.tcl -notrace

#copy the simulations file to the src file
while read line
do
    cp $line ./sim/src
done < ./sim/sim_file.f

#copy sim weights files
cp ./build/coe/weights_sim.dat ./sim/data

#copy the mif file to the testbench
rm ./sim/tb/*.mif
while read line
do
    cp $line ./sim/tb
done < ./sim/mif_file.f

