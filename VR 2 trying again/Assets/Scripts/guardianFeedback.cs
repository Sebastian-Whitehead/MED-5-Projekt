using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class guardianFeedback : MonoBehaviour {
    public Material staticMaterial;
    public Material feedbackMaterial;
    public float speed = 0.5f;

    private bool alert = false;
    private float lerp = 1f;
    private Renderer rend;

    // Start is called before the first frame update
    void Start() {
        rend = GetComponent<Renderer>();
    }

    // Update is called once per frame
    void Update() {
        if (lerp < 1) {
            lerp += speed / 10;
            if (alert) {
                rend.material.Lerp(staticMaterial, feedbackMaterial, lerp);
            } else {
                rend.material.Lerp(feedbackMaterial, staticMaterial, lerp);
            }
        }
    }

    void OnTriggerEnter(Collider other) {
        if (other.gameObject.tag == "TrackingObject") {
            Debug.Log("Tracking object enter guardian");
            alert = false;
            lerp = 0f;
        }
    }

    void OnTriggerExit(Collider other) {
        if (other.gameObject.tag == "TrackingObject") {
            Debug.Log("Tracking object exiting guardian");
            alert = true;
            lerp = 0f;
        }
    }
}
