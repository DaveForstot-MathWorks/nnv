# nnv
Matlab Toolbox for Neural Network Verification

This toolbox implements reachability methods for analyzing neural networks, particularly with a focus on closed-loop controllers in autonomous cyber-physical systems (CPS).

# related tools and software

This toolbox makes use of the neural network model transformation tool ([nnmt](https://github.com/verivital/nnmt)) and for closed-loop systems analysis, the hybrid systems model transformation and translation tool ([HyST](https://github.com/verivital/hyst)).

# installation:
    1) Install Matlab

    2) Clone or download the nnv toolbox from [https://github.com/verivital/nnv]

    3) Open matlab, then go to the directory where nnv exists on your machine, then run the `install.m` script located at /nnv/

# uninstallation:

    1) Open matlab, then go to `/nnv/` and execute the `uninstall.m` script

# running tests and examples

    Go into the `tests/examples` folders to execute the scripts for testing/analyzing examples.


# novel features

1) NNV can compute and visualize the exact reachable sets of feedforward nerual networks with ReLU/Saturation activation functions. The computation can be accelerated using parallel computing in Matlab. The computed reachable set can be used for safety verification of the networks.

<figure>
    <img src="images/ACASXu.png"> <figcaption>Vertical view of a generic example of the ACAS Xu benchmark set</figcaption>
</figure>

<figure>
    <img src="images/reachSetP4.png" width="600" height="400"> <figcaption>Exact reachable set of a ACAS Xu network</figcaption>
</figure>

<figure>
    <img src="images/verificationTime.png" width="400" height="300"  > <figcaption>Verification time (VT) can be reduced by increasing the number of cores (N) </figcaption>
</figure>

<figure>
    <img src="images/reachSetP4s.png"> <figcaption>Reachable set of a ACAS Xu network with different methods</figcaption>
</figure>

2) NNV can construct and visualize the complete counter inputs of feedforward neural networks with ReLU/Saturation activation functions.

<figure>
    <img src="images/counterInputSet.png" width="600" height="300"> <figcaption>An Complete Set of Counter Inputs of a ACASXu network</figcaption>
</figure>

3) NNV can compute and visualize the over-approximate reachable sets of feedforward neural networks with Tanh, Sigmoid activation functions.

<figure>
    <img src="images/sigmoidReachSet.png" width="400" height="300"> <figcaption>Reachable set of a network with Sigmoid activation functions</figcaption>
</figure>

4) NNV can compute and visualize the reachable sets of neural network control systems, i.e., systems with plant + neural network controllers which can be used to verify or falsify safety properties of the systems.

<figure>
    <img src="images/ACC.png"> <figcaption>Neural Network Adaptive Cruise Control System</figcaption>
</figure>

<figure>
    <img src="images/ACCreachSet.png" width="400" height="300"> <figcaption>Reachable set of the neural network adaptive cruise control system</figcaption>
</figure>

<figure>
    <img src="images/falsifyTrace.png" width="400" height="300"> <figcaption>A fasification trace of the neural network adaptive cruise control system</figcaption>
</figure>

<figure>
    <img src="images/EBS.png" width="400" height="200"> <figcaption>Advaced Emergency Braking System with Reinforcement Controller</figcaption>
</figure>

<figure>
    <img src="images/EBreachSet.png" width="400" height="300"> <figcaption>Reachable set of the advanced emergency braking system with reinforcement controller</figcaption>
</figure>


<figure>
    <img src="images/SafeInitCondition.png" width="400" height="300"> <figcaption>Safe initial condition of the advanced emergency braking system with reinforcement controller</figcaption>
</figure>


# contributors

* [Hoang-Dung Tran](https://scholar.google.com/citations?user=_RzS3uMAAAAJ&hl=en)
* [Weiming Xiang](https://scholar.google.com/citations?user=Vm_7JP8AAAAJ&hl=en)
* [Patrick Musau](https://scholar.google.com/citations?user=C2RS3i8AAAAJ&hl=en)
* [Diego Manzanas Lopez](https://scholar.google.com/citations?user=kgpZCIAAAAAJ&hl=en)
* Xiaodong Yang
* [Luan Viet Nguyen](https://luanvietnguyen.github.io)
* [Taylor T. Johnson](http://www.taylortjohnson.com)

# references

The methods implemented in nnv are based upon the following papers.

1. Hoang-Dung Tran, Patrick Musau, Diego Manzanas Lopez, Xiaodong Yang, Luan Viet Nguyen, Weiming Xiang, Taylor T.Johnson, "Star-Based Reachability Analsysis for Deep Neural Networks", Submitted to The 23rd International Symposisum on Formal Methods (3rd World Congress on Formal Methods, FM2019). [http://taylortjohnson.com/research/tran2019fm.pdf]

2. Hoang-Dung Tran, Feiyang Cei, Diego Manzanas Lopez, Taylor T.Johnson, Xenofon Koutsoukos, "Safety Verification of Cyber-Physical Systems with Reinforcement Learning Control", under review. [http://taylortjohnson.com/research/tran2019emsoft.pdf]

3. Hoang-Dung Tran, Patrick Musau, Diego Manzanas Lopez, Xiaodong Yang, Luan Viet Nguyen, Weiming Xiang, Taylor T.Johnson, "Parallelzable Reachability Analsysis Algorithms for FeedForward Neural Networks", In 7th International Conference on Formal Methods in Software Engineering (FormaLISE), 27, May, 2019 in Montreal, Canada [http://taylortjohnson.com/research/tran2019formalise.pdf]

4. Weiming Xiang, Hoang-Dung Tran, Taylor T. Johnson, "Output Reachable Set Estimation and Verification for Multi-Layer Neural Networks", In IEEE Transactions on Neural Networks and Learning Systems (TNNLS), 2018, March. [http://taylortjohnson.com/research/xiang2018tnnls.pdf]

5. Weiming Xiang, Hoang-Dung Tran, Taylor T. Johnson, "Reachable Set Computation and Safety Verification for Neural Networks with ReLU Activations", In In Submission, IEEE, 2018, September. [http://www.taylortjohnson.com/research/xiang2018tcyb.pdf]

6. Weiming Xiang, Diego Manzanas Lopez, Patrick Musau, Taylor T. Johnson, "Reachable Set Estimation and Verification for Neural Network Models of Nonlinear Dynamic Systems", In Unmanned System Technologies: Safe, Autonomous and Intelligent Vehicles, Springer, 2018, September. [http://www.taylortjohnson.com/research/xiang2018ust.pdf]

7. Reachability Analysis and Safety Verification for Neural Network Control Systems, Weiming Xiang, Taylor T. Johnson [https://arxiv.org/abs/1805.09944]

8. Weiming Xiang, Patrick Musau, Ayana A. Wild, Diego Manzanas Lopez, Nathaniel Hamilton, Xiaodong Yang, Joel Rosenfeld, Taylor T. Johnson, "Verification for Machine Learning, Autonomy, and Neural Networks Survey," October 2018, [https://arxiv.org/abs/1810.01989]

8. Specification-Guided Safety Verification for Feedforward Neural Networks, Weiming Xiang, Hoang-Dung Tran, Taylor T. Johnson [https://arxiv.org/abs/1812.06161]

9. Diego Manzanas Lopez, Patrick Musau, Hoang-Dung Tran, Taylor T.Johnson, "Verification of Closed-loop Systems with Neural Network Controllers (Benchmark Proposal)", The 6th International Workshop on Applied Verification of Continuous and Hybrid Systems (ARCH2019). Montreal, Canada, 2019. [http://taylortjohnson.com/research/lopez2019arch.pdf]

10. Diego Manzanas Lopez, Patrick Musau, Hoang-Dung Tran, Souradeep Dutta, Taylor J. Carpenter, Radoslav Ivanov, Taylor T.Johnson, "ARCH-COMP19 Category Report: Artificial Intelligence / Neural Network Control Systems (AINNCS) for Continuous and Hybrid Systems Plants", 3rd International Competition on Verifying Continuous and Hybrid Systems (ARCH-COMP2019), The 6th International Workshop on Applied Verification of Continuous and Hybrid Systems (ARCH2019). Montreal, Canada, 2019. [http://taylortjohnson.com/research/lopez2019archcomp.pdf]

# acknowledgements

This work is supported in part by the [DARPA Assured Autonomy](https://www.darpa.mil/program/assured-autonomy) program.
