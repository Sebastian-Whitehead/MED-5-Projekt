using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Count : MonoBehaviour {
    public int counting = 0;

    public void countUp() {
        counting++;
        Debug.Log(counting);
    }
}
