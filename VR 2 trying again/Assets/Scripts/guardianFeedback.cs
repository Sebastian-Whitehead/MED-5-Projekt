using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class guardianFeedback : MonoBehaviour {
    public Material staticMaterial;     //Standard Guardian Meterial   
    public Material feedbackMaterial;   // Material for when the user is leaving the guardian space
    public float speed = 0.5f;          // Texture interpolation speed

    private bool alert = false;         // Is there a tracking object outside the designated guardian
    private Renderer rend;              // Guardian Render material
    private int _trackObjsInside = 0;   // Number of tracking objects inside the guardian collider
    
    private float lerp = 1f;            // Interpolation value
    
    void Start() {
        rend = GetComponent<Renderer>();
    }

    // Update is called once per frame
    void Update() {
        //Debug.Log(_trackObjsInside);
        if (lerp < 1) {
            lerp += speed / 10;
            if (alert) {
                rend.material.Lerp(staticMaterial, feedbackMaterial, lerp); // Fade from standard to the feedback material
            } else {
                rend.material.Lerp(feedbackMaterial, staticMaterial, lerp); // Fade from feedback to standard material
            }
        }
    }

    void OnTriggerEnter(Collider other) {
        if (other.gameObject.CompareTag("TrackingObject"))
        {
            _trackObjsInside++;
            Debug.Log("Tracking object enter guardian");
            if (_trackObjsInside == 3)
            {
                alert = false;
                lerp = 0f;
            }
        }
    }

    void OnTriggerExit(Collider other) {
        if (other.gameObject.CompareTag("TrackingObject"))
        {
            _trackObjsInside--;
            Debug.Log("Tracking object exiting guardian");
            if (_trackObjsInside == 2)
            {
                alert = true;
                lerp = 0f;
            }
        }
    }
}
