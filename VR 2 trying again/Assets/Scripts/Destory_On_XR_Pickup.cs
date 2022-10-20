using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Destory_On_XR_Pickup : MonoBehaviour
{
    public void DestoryGameObject()
    {
        Destroy(gameObject, 1.5f);
        //Debug.Log("Detoryed Picked Up Object");
    }
    
}
