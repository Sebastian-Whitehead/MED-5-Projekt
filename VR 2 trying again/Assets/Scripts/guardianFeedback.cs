using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class guardianFeedback : MonoBehaviour {
    public Material staticMaterial;     //Standard Material 
    public Material feedbackMaterial;   //Transition Material
    public float speed = 0.5f;          //Transition Speed             

    private bool alert = false;         //Weather object is outside of play-space
    private float lerp = 1f;            //Interpolation variable 
    private Renderer rend;              //The Objects renderer
    
    private int insides = 0;

    // Start is called before the first frame update
    void Start() {
        rend = GetComponent<Renderer>();// Retrieves renderer 
    }

    // Update is called once per frame
    void Update() {
        
        //Debug.Log(insides);
        if (lerp < 1) {
            lerp += speed / 10;
            if (alert) {
                rend.material.Lerp(staticMaterial, feedbackMaterial, lerp); // Fade from standard to feedback material  
            } else {
                rend.material.Lerp(feedbackMaterial, staticMaterial, lerp); // Fade from feedback to standard material
            }
        }
    }

    void OnTriggerEnter(Collider other) {
        if (other.gameObject.tag == "TrackingObject")
        {
            insides++;
            
            //Debug.Log("Tracking object enter guardian");
            
            if (insides == 3)
            {
                alert = false;
                lerp = 0f;
            }
        }
    }

    void OnTriggerExit(Collider other) {
        if (other.gameObject.tag == "TrackingObject")
        {

            insides--;
            //Debug.Log("Tracking object exiting guardian");

            if (insides == 2)
            {
                alert = true;
                lerp = 0f;
            }
        }
    }
}
