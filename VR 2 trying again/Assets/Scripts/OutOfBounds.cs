using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class OutOfBounds : MonoBehaviour
{
    public FadeScreen ThefadingScreen;
    
    void OnTriggerEnter(Collider other) {
        if (other.gameObject.CompareTag("TrackingObject") && other.gameObject.name == "Body")
        {
            Debug.Log("Tracking object enter guardian");
            ThefadingScreen.Fade(0.991f, 0f, 1f);
        }
    }

    void OnTriggerExit(Collider other)
    {
        if (other.gameObject.CompareTag("TrackingObject") && other.gameObject.name == "Body")
        {
            Debug.Log("Tracking object exiting guardian");
            ThefadingScreen.Fade(0f, 0.991f, 1f);
        }
    }
}
