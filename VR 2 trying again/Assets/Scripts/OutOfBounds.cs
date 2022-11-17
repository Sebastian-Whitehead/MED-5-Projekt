using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class OutOfBounds : MonoBehaviour
{
    public FadeScreen fadingScreen;
    
    void OnTriggerEnter(Collider other) {
        if (other.gameObject.CompareTag("TrackingObject") && other.gameObject.name == "Body")
        {
            Debug.Log("Tracking object enter guardian");
            fadingScreen.Fade(0.999f, 0f, 1f);
        }
    }

    void OnTriggerExit(Collider other)
    {
        if (other.gameObject.CompareTag("TrackingObject") && other.gameObject.name == "Body")
        {
            Debug.Log("Tracking object exiting guardian");
            fadingScreen.Fade(0f, 0.999f, 1f);
        }
    }
}
