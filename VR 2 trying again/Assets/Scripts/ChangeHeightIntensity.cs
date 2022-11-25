using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.XR;

public class ChangeHeightIntensity : MonoBehaviour
{

    private Renderer rend;
    private float ValUpperLerpL = 0.09f;
    private float ValLowerLerpL = -0.463f; 
    private float ValUpperLerpS = 0.01f;
    private float ValLowerLerpS = 0f;

    private float ValTransL = 0.179f;

    private float ValTransS = 0.136f;

    public GameObject Guardian;


    private void Start()
    {
     
    }

    // Update is called once per frame
    void Update(){

      var rightHandedControllers = new List<UnityEngine.XR.InputDevice>();
      var desiredCharacteristicsright = UnityEngine.XR.InputDeviceCharacteristics.HeldInHand | UnityEngine.XR.InputDeviceCharacteristics.Right | UnityEngine.XR.InputDeviceCharacteristics.Controller;
      UnityEngine.XR.InputDevices.GetDevicesWithCharacteristics(desiredCharacteristicsright, rightHandedControllers);


      var leftHandedControllers = new List<UnityEngine.XR.InputDevice>();
      var desiredCharacteristicsleft = UnityEngine.XR.InputDeviceCharacteristics.HeldInHand | UnityEngine.XR.InputDeviceCharacteristics.Left | UnityEngine.XR.InputDeviceCharacteristics.Controller;
      UnityEngine.XR.InputDevices.GetDevicesWithCharacteristics(desiredCharacteristicsleft, leftHandedControllers);

      bool leftprimaryval;
      bool leftsecondaryval;
      Vector2 leftstick;
      
      foreach (var device in leftHandedControllers)
      {
        if (device.TryGetFeatureValue(UnityEngine.XR.CommonUsages.primary2DAxis, out leftstick)){
        Guardian.GetComponent<Renderer>().sharedMaterial.SetFloat("_TransL", ValTransL);
        Guardian.GetComponent<Renderer>().sharedMaterial.SetFloat("_TransS", ValTransS);
        float yvalue = leftstick.y;
        //Modifies the Transparency Values for TransL
        ValTransL += yvalue/10;
        if (ValTransL >= 1f){
          ValTransL = 1f;
        }
        if (ValTransL <= 0f){
          ValTransL = 0f;
        }

        //Modifies the transparency values for TransS
        ValTransS += yvalue/10;
        if (ValTransS >= 1f){
          ValTransS = 1f;
        }
        if (ValTransS <= 0f){
          ValTransS = 0f;
        }

    }

          if (device.TryGetFeatureValue(UnityEngine.XR.CommonUsages.primaryButton, out leftprimaryval) && leftprimaryval){
          Debug.Log("left primary button is pressed.");
        }

        if(device.TryGetFeatureValue(UnityEngine.XR.CommonUsages.secondaryButton, out leftsecondaryval) && leftsecondaryval){
        Debug.Log("Left secondary bUtToN is pressed");
        }
      }

      bool rightprimaryval;
      bool rightsecondaryval;
      Vector2 rightstick; 
      foreach (var device in rightHandedControllers){

       if (device.TryGetFeatureValue(UnityEngine.XR.CommonUsages.primary2DAxis, out rightstick)){
          Guardian.GetComponent<Renderer>().sharedMaterial.SetFloat("_UpperLerpL", ValUpperLerpL);
          Guardian.GetComponent<Renderer>().sharedMaterial.SetFloat("_LowerLerpL", ValLowerLerpL);
          Guardian.GetComponent<Renderer>().sharedMaterial.SetFloat("_UpperLerpS", ValUpperLerpS);
          Guardian.GetComponent<Renderer>().sharedMaterial.SetFloat("_LowerLerpS", ValLowerLerpS);
          float yvalue = rightstick.y;
        
          ValUpperLerpL += yvalue/10;
          if (ValUpperLerpL >= 2){
            ValUpperLerpL= 2f;
          }
          if (ValUpperLerpL <= 0.01f){
            ValUpperLerpL = 0.015f;
          }

          ValLowerLerpL += yvalue/10;
          if (ValUpperLerpL >= 1){
            ValUpperLerpL= 1f;
          }
          if (ValLowerLerpL <= 0f){
            ValUpperLerpL = 0.01f;
          }

          ValUpperLerpS += yvalue/10;
          if (ValUpperLerpS >= 2){
            ValUpperLerpS= 2f;
          }
          if (ValUpperLerpS <= 0.01f){
            ValUpperLerpS = 0.01f;
          }

          ValLowerLerpS += yvalue/10;
          if (ValUpperLerpS >= 1){
            ValUpperLerpS= 1f;
          }
          if (ValLowerLerpS <=0f){
            ValUpperLerpS = 0.01f;
          }

       
       
       
       }

      if (device.TryGetFeatureValue(UnityEngine.XR.CommonUsages.primaryButton, out rightprimaryval) && rightprimaryval)
      {
          Debug.Log("right primary button is pressed.");
      }
      if (device.TryGetFeatureValue(UnityEngine.XR.CommonUsages.secondaryButton, out rightsecondaryval) && rightsecondaryval)
      {
          
      }
      }
      
    }

}
