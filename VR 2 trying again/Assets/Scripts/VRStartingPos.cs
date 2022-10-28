using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.SceneManagement;

public class VRStartingPos : MonoBehaviour
{
    public CheckPosCollision leftHandZone;
    public CheckPosCollision rightHandZone;
    public SceneTransitionManager transitionManager;

    public GameObject viewTarget;
    private Renderer _targetRenderer;
    private bool _lookingAt = false;
    private string targetScene;

    // Start is called before the first frame update
    void Start()
    {
        _targetRenderer = viewTarget.GetComponent<Renderer>();
    }

    // Update is called once per frame
    void Update()
    {
        var ray = new Ray(this.transform.position, this.transform.forward);
        RaycastHit hit;
        if(Physics.Raycast(ray, out hit))
        {
            if (viewTarget.name == hit.transform.gameObject.name)
            {
                viewTarget.GetComponent<Renderer>();
                _targetRenderer.material.color = Color.green;
                _lookingAt = true;
                CheckStartingPos();
            }
            else
            {
                _targetRenderer.material.color = Color.red;
                _lookingAt = false;
            
            }
        }
        
        if (Input.GetKeyDown(KeyCode.Alpha1))
        {
            targetScene = "VR 1";
        }
        if (Input.GetKeyDown(KeyCode.Alpha2))
        {
            targetScene = "VR 2";
        }
    }

    // ReSharper disable Unity.PerformanceAnalysis
    void CheckStartingPos()
    {
        if (leftHandZone.CheckCollision() && rightHandZone.CheckCollision() && _lookingAt)
        {
            //Debug.Log("All requirements met");
            if (targetScene != null)
            {
                transitionManager.GoToScene(targetScene);
            }
        }
    }
}
