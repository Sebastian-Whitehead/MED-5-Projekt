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
    private float maxval = 0.2f;
    public GameObject Guardian;
    public Hand hand;

    private InputDevice targetDevice;
    
    // Start is called before the first frame update
    void Start()
    {

        // rend = GetComponent<Renderer> ();
        // rend.material.shader = Shader.Find("Fixed_Solo-pass");
         List<InputDevice> devices = new List<InputDevice>();
         InputDevices.GetDevices(devices);

    //     foreach(var item in devices){
    //       Debug.Log(item.name + item.characteristics);
    //     }

    //      InputDeviceCharacteristics rightControllerCharacteristics = InputDeviceCharacteristics.Right | InputDeviceCharacteristics.Controller;
    //      InputDevices.GetDeviceWithCharacteristics(rightControllerCharacteristics, devices);

      if (devices.Count > 0){
        targetDevice = devices [0];
      }
    }

    // Update is called once per frame
    void Update()
    {

         targetDevice.TryGetFeatureValue(CommonUsages.primaryButton, out bool primaryButtonValue);
        if(primaryButtonValue == true){
            Debug.Log("Works");
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
