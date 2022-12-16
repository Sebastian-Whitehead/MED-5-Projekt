using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class OutOfBounds : MonoBehaviour
{
    public FadeScreen fadingScreen; // Fade screen component on the fading screen game object
    
    void OnTriggerEnter(Collider other) 
    { // When the body game object leaves the collider obscure the view of the player with the fade screen
        if (other.gameObject.CompareTag("TrackingObject") && other.gameObject.name == "Body")
        {
            Debug.Log("Tracking object enter guardian");
            fadingScreen.Fade(0.999f, 0f, 1f);
        }
    }

    void OnTriggerExit(Collider other) 
    { // When the body re-enters the play-space un-obscure the player view. 
        if (other.gameObject.CompareTag("TrackingObject") && other.gameObject.name == "Body")
        {
            Debug.Log("Tracking object exiting guardian");
            fadingScreen.Fade(0f, 0.999f, 1f);
        }
    }
}
