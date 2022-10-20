using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class DestroyOnXRPickup : MonoBehaviour
{
    public void DestroyGameObject()
    {
        Destroy(gameObject, 1.5f);
        //Debug.Log("Destroyed Picked Up Object" after 1.5 seconds);
    }
    
}
