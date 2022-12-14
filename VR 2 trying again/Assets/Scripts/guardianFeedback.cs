using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class guardianFeedback : MonoBehaviour {
    public Material staticMaterial;     //Standard Material 
    public Material feedbackMaterial;   //Transition Material
    public float speed = 0.5f;          //Transition Speed             

    private bool _alert = false;         //Weather object is outside of play-space
    private float _lerp = 1f;            //Interpolation variable 
    private Renderer _rend;              //The Objects renderer
    
    private int _insides = 0;

    // Start is called before the first frame update
    void Start() {
        _rend = GetComponent<Renderer>();// Retrieves renderer 
    }

    // Update is called once per frame
    void Update() {
        
        //Debug.Log(insides);
        if (_lerp < 1) {
            _lerp += speed / 10;
            if (_alert) {
                _rend.material.Lerp(staticMaterial, feedbackMaterial, _lerp); // Fade from standard to feedback material  
            } else {
                _rend.material.Lerp(feedbackMaterial, staticMaterial, _lerp); // Fade from feedback to standard material
            }
        }
    }

    void OnTriggerEnter(Collider other) {
        if (other.gameObject.CompareTag("TrackingObject")) // When a tracking object enters the guardian
        {
            _insides++; // Update number of tracking numbers inside guardian

            if (_insides == 3)  // If all tracking objects are inside the guardian fade to standard guardian
            {
                _alert = false;
                _lerp = 0f;
            }
        }
    }

    void OnTriggerExit(Collider other) { 
        if (other.gameObject.CompareTag("TrackingObject")) // If tracking object leaves guardian collider
        {
            _insides--;     // Reduce number of tracking objects within guardian

            /* When the number of objects leaving the guardian is exactly two trigger warning barrier
            This state remains until all three tracking objects are back within the guardian collider */
            if (_insides == 2) 
            {
                _alert = true;
                _lerp = 0f;
            }
        }
    }
}
