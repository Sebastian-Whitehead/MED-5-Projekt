# Persistent Guardian Testing Eviroment

### Description:
This repository was created in conjunction with the 5. semester, semester project and created to test the premis of a visually persistent virtual reality guardian system, against a control (*Meta's Quest 2 stock guardian*) in a 3x3 meter play-space. In this environment the program is capable of recording second to second user position and speed(*m/s*) as quantitative data for user movement behavior during guardian comparison.
***
### Installation:
The Unity enviroment within this repository consist of 3 scenes 2 created to be a representative VR environment (*have 1, have 2*). The last being a control scene to premote all users starting in a similar orientation and position (*startup scene*). The VR environment itself uses the [Unity XR interaction toolkit](https://docs.unity3d.com/Packages/com.unity.xr.interaction.toolkit@2.2/manual/index.html) to create basic VR compatibility. 

Download whatever software is required to connect and run the respective headset from a VR capable windows computer. Once connection with the headset is established running the Unity enviroment should automatically place the into the selected scene.

***
### Usage:
When starting the unity program the user should first be loaded into the startup scene where they are asked to place one hand into each of the red spheres (*These should turn green when a hand is present within*). With a hand in each the user must then look at the center of the target infront of them (*Should also turn green*). While the user achieves this 3 point position the test conductor must press the '1' or '2' number key on the computer in order to determine which enviroment is switched to when the correct position is reached by the user.
*It is recommended to disable the default guardian when using the provided persistent guardian as otherwise both guardians will be visible, and overlap*

When in the two subsequent testing enviroments the users head position is logged every second from which a speed value is calculated. The user can then procede around the environment and collect a series of eggs which vanish after a second's delay. Once stopped this logged data can be found in a csv file under the 'CSV' folder. Each play session is marked by a "New participant" in this csv file.

> ??? **Note**:
> The collection of these eggs is purely an encouragement for user movement and not a measured parameter. 

##### Shader Settings:
The packaged guardians shader material has a series of settings which allow adjustment of its' visual appearance. These include the following:

###### Major & Minor sections:
- **Lower Lerp:** Bottom point for either of the two overlapping gradients  
- **Upper Lerp:** Top height for either of the two overlapping gradients
- **Trans:** Transparency for the given gradient

###### Overall:
- **OSS trans:** Visibility level of both gradients when obscured by any given virtual object
***

### Authors:
- *Unity Environment & VR integration:* Sebastian Whitehead
- *Shaders:* Tonko Bossen & Charlotte Johansen
- *Data logging procedure:* Tobias Kiholm
- *Setup Prodcedure / Scene:* Rebecca Hansen & Sebastian Whitehead
- *3D models:* Tonko Bossen, Charlotte Johansen, Tobias Kiholm & Rebecca Hansen
***

### Sources: 
[Oculus hand models](https://developer.oculus.com/downloads/package/oculus-hand-models/)
