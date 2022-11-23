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
      foreach (var device in leftHandedControllers)
      {
          if (device.TryGetFeatureValue(UnityEngine.XR.CommonUsages.primaryButton, out leftprimaryval) && leftprimaryval)
      {
          Debug.Log("left primary button is pressed.");
      
      }
        if(device.TryGetFeatureValue(UnityEngine.XR.CommonUsages.secondaryButton, out leftsecondaryval) && leftsecondaryval){
          Debug.Log("Left secondary bUtToN is pressed");
        }
      }

      bool rightprimaryval;
      bool rightsecondaryval;
      foreach (var device in rightHandedControllers){
        
      if (device.TryGetFeatureValue(UnityEngine.XR.CommonUsages.primaryButton, out rightprimaryval) && rightprimaryval)
      {
          Debug.Log("right primary button is pressed.");
          Guardian.GetComponent<Renderer>().sharedMaterial.SetFloat("_UpperLerpL", ValUpperLerpL);
          Guardian.GetComponent<Renderer>().sharedMaterial.SetFloat("_LowerLerpL", ValLowerLerpL);
          Guardian.GetComponent<Renderer>().sharedMaterial.SetFloat("_UpperLerpS", ValUpperLerpS);
          Guardian.GetComponent<Renderer>().sharedMaterial.SetFloat("_LowerLerpS", ValLowerLerpS);
          
          if (ValUpperLerpL >= 0.01f){
              ValUpperLerpL -= 0.015f;
          }
          if(ValLowerLerpL >= 0f){
            ValLowerLerpL -= 0.01f;
          }
          if(ValUpperLerpS >= 0.01f){
            ValUpperLerpS -= 0.01f;
          }
          if(ValLowerLerpS >= 0f){
            ValLowerLerpS -= 0.01f;
          } 

      }
        if (device.TryGetFeatureValue(UnityEngine.XR.CommonUsages.secondaryButton, out rightsecondaryval) && rightsecondaryval)
      {
          Debug.Log("right secondary button is pressed.");
          Guardian.GetComponent<Renderer>().sharedMaterial.SetFloat("_UpperLerpL", ValUpperLerpL);
          Guardian.GetComponent<Renderer>().sharedMaterial.SetFloat("_LowerLerpL", ValLowerLerpL);
          Guardian.GetComponent<Renderer>().sharedMaterial.SetFloat("_UpperLerpS", ValUpperLerpS);
          Guardian.GetComponent<Renderer>().sharedMaterial.SetFloat("_LowerLerpS", ValLowerLerpS);

            if (ValUpperLerpL <= 2f){
              ValUpperLerpL += 0.015f;
            }
            if (ValLowerLerpL <= 1f){
              ValLowerLerpL +=0.01f;
            } 
            if (ValUpperLerpS <= 2f){
              ValUpperLerpS += 0.01f; 
            }
            if (ValLowerLerpS <= 1f){
              ValLowerLerpS += 0.01f;
            }
      }
      }

      if(Input.GetKeyDown("up")){
        Guardian.GetComponent<Renderer>().sharedMaterial.SetFloat("_UpperLerpL", ValUpperLerpL);
        Guardian.GetComponent<Renderer>().sharedMaterial.SetFloat("_LowerLerpL", ValLowerLerpL);
        Guardian.GetComponent<Renderer>().sharedMaterial.SetFloat("_UpperLerpS", ValUpperLerpS);
        Guardian.GetComponent<Renderer>().sharedMaterial.SetFloat("_LowerLerpS", ValLowerLerpS);

          if (ValUpperLerpL <= 2f){
            ValUpperLerpL += 0.015f;
          }
          if (ValLowerLerpL <= 1f){
            ValLowerLerpL +=0.01f;
          } 
          if (ValUpperLerpS <= 2f){
            ValUpperLerpS += 0.01f; 
          }
          if (ValLowerLerpS <= 1f){
            ValLowerLerpS += 0.01f;
          }

        }

        if(Input.GetKeyDown("down")){
        Guardian.GetComponent<Renderer>().sharedMaterial.SetFloat("_UpperLerpL", ValUpperLerpL);
        Guardian.GetComponent<Renderer>().sharedMaterial.SetFloat("_LowerLerpL", ValLowerLerpL);
        Guardian.GetComponent<Renderer>().sharedMaterial.SetFloat("_UpperLerpS", ValUpperLerpS);
        Guardian.GetComponent<Renderer>().sharedMaterial.SetFloat("_LowerLerpS", ValLowerLerpS);
        
        if (ValUpperLerpL >= 0.01f){
            ValUpperLerpL -= 0.015f;
        }
        if(ValLowerLerpL >= 0f){
          ValLowerLerpL -= 0.01f;
        }
        if(ValUpperLerpS >= 0.01f){
          ValUpperLerpS -= 0.01f;
        }
        if(ValLowerLerpS >= 0f){
          ValLowerLerpS -= 0.01f;
        } 
      }
      
    }

}
