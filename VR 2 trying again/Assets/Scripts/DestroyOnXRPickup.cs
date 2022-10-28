using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class DestroyOnXRPickup : MonoBehaviour {
    public gameObject counter;

    public void DestroyGameObject() {
        counter.Count.countUp();
        gameObject.Find(countiing).GetComponent<Count>().countUp();

        Destroy(gameObject, 1.5f);
    }
}