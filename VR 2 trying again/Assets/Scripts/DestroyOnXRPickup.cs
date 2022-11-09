using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.Android;

public class DestroyOnXRPickup : MonoBehaviour
{

    private ObjectAudioManager _audioManager;
    private Count _counter;

    private void Start()
    {
        _counter = GameObject.Find("Counter").GetComponent<Count>();      // Get the Count Class from the Counter UI Game Object
        _audioManager = gameObject.GetComponent<ObjectAudioManager>();    // Get the ObjectAudioManager Script from this game object
    }

    public void DestroyGameObject() {
        _audioManager.PlaySoundFromObject(0);        // Play pickup sound effect from ObjectAudioManager
        StartCoroutine(DelayAction(1f));    // Start Delay Subroutine
    }

    // ReSharper disable Unity.PerformanceAnalysis
    IEnumerator DelayAction(float delaytime)
    {
        //Wait for the specified delay time before continuing
        yield return new WaitForSeconds(delaytime);
        
        //Do the action after the delay time has finished
         _audioManager.PlaySoundFromObject(1);   // Play the pop sound effect from the ObjectAudioManager
        Destroy(gameObject);    // Destroy Current Game Object
        _counter.countUp();     // Count up the number of eggs collected
       
    }

}