using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.SceneManagement;

public class VRStartingPos : MonoBehaviour
{
    // Target objects in startup scene
    public CheckPosCollision leftHandZone;
    public CheckPosCollision rightHandZone;
    public GameObject viewTarget;
    
    // Transition manager
    public SceneTransitionManager transitionManager;
    
    // Internal variables
    private Renderer _targetRenderer;
    private bool _lookingAt = false;
    private string _targetScene;

    // Start is called before the first frame update
    void Start()
    {
        _targetRenderer = viewTarget.GetComponent<Renderer>(); // Get renderer
    }

    // Update is called once per frame
    void Update()
    {
        var transform1 = this.transform;
        var ray = new Ray(transform1.position, transform1.forward);
        if(Physics.Raycast(ray, out var hit))
        {
            if (viewTarget.name == hit.transform.gameObject.name) 
            {    // If looking at target change target color and check hand positions
                viewTarget.GetComponent<Renderer>();
                _targetRenderer.material.color = Color.green;
                _lookingAt = true;
                CheckStartingPos();
            }
            else // Revert color and state
            {
                _targetRenderer.material.color = Color.red;
                _lookingAt = false;
            
            }
        }
        // Change target scene based on number row key press by test conductor
        if (Input.GetKeyDown(KeyCode.Alpha1))  
        {
            _targetScene = "VR 1";
        }
        if (Input.GetKeyDown(KeyCode.Alpha2))
        {
            _targetScene = "VR 2";
        }
    }

    // ReSharper disable Unity.PerformanceAnalysis
    void CheckStartingPos() // Check to see weather hand positions are within target spheres
    {
        if (leftHandZone.CheckCollision() && rightHandZone.CheckCollision() && _lookingAt)
        {
            //Debug.Log("All requirements met");
            if (_targetScene != null)
            {
                transitionManager.GoToScene(_targetScene);  // Change scene
                viewTarget.GetComponent<AudioClip>();
                
            }
        }
    }
}
