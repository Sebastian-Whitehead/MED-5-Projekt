using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.InputSystem;
public class ChangeHeightIntensity : MonoBehaviour
{

    private Renderer rend;
    private float ValUpperLerpL = 0.09f;
    private float ValLowerLerpL = -0.463f; 
    private float ValUpperLerpS = 0.01f;
    private float ValLowerLerpS = 0f;
    public GameObject Guardian;
    private InputAction rightHandPrimaryButton;
    
    [SerializeField] private InputActionReference primaryButton;
    private void Start()
    {
      
    }

    // Update is called once per frame
    void Update(){

      if (Input.GetKeyDown("primaryButton"))
      {
        Debug.Log("Pls");
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
