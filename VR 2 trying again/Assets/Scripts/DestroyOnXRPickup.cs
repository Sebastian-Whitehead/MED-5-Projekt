using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class DestroyOnXRPickup : MonoBehaviour {

    public void DestroyGameObject() {
        gameObject.GetComponent<Count>().countUp();
        
        Destroy(gameObject, 1.5f);
    }
}