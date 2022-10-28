using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class DestroyOnXRPickup : MonoBehaviour {
    public void DestroyGameObject() {
        Destroy(gameObject, 1.5f);
        //Debug.Log("Destroyed Picked Up Object" after 1.5 seconds);

        // // Count eggs destroyed
        // TMP_Text counter = gameObject.Find("Counter").GetComponent<TMP_Text>();
        // int currentCounter = int.Parse(counter.text);
        // currentCounter++;
        // counter.text = currentCounter.ToString();
    }
}