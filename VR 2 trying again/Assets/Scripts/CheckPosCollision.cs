using System;
using System.Collections;
using System.Collections.Generic;
using Unity.VisualScripting;
using UnityEngine;

public class CheckPosCollision : MonoBehaviour
{
    private Renderer _renderer;           // This game object's renderer
    public GameObject target;             // Controller game object
    private bool _collisionState = false; // Current collision state

    private void Start()
    {
        _renderer = GetComponent<Renderer>();   // Get the object renderer
    }

    private void OnTriggerEnter(Collider col)
    {
        if (col.name == target.name)            // If the target colliding object is the target object
        {
            //Debug.Log(" Correct collision!");
            _renderer.material.color = Color.green; // change this object's color to green 
            _collisionState = true;                 // Set the current collision state to true
        }
    }

    private void OnTriggerExit(Collider col)   // When leaving the collider
    {
        _renderer.material.color = Color.red;  // Set color to red
        _collisionState = false;               // set collision state to false
    }

    public bool CheckCollision()               // Getter function to be called by external game - objects
    {
        return _collisionState;                 
    }
}
