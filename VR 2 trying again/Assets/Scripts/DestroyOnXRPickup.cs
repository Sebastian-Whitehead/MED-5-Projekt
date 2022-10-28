using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class DestroyOnXRPickup : MonoBehaviour {

    public void DestroyGameObject() {
        GameObject.Find("Counter").GetComponent<Count>().countUp();

        Destroy(gameObject, 1f);
    }
}